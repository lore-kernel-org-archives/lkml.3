Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaFYUFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:05:51 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:40693 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaFYUFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:05:50 -0400
Message-ID: <1403726744.2581.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] tools: msgque improve error handling when not running
 as root
From: Davidlohr Bueso <davidlohr@hp.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        colin.king@canonical.com, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 13:05:44 -0700
In-Reply-To: <1403725210-10245-1-git-send-email-shuah.kh@samsung.com>
References: <1403725210-10245-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 13:40 -0600, Shuah Khan wrote:
> The test fails in the middle when it is not run as root while
> accessing /proc/sys/kernel/msg_next_id. Changed it to check
> for root at the beginning of the test. Also added messages
> to indicate start and test pass status.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  tools/testing/selftests/ipc/msgque.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
> index aa290c0..30c627a 100644
> --- a/tools/testing/selftests/ipc/msgque.c
> +++ b/tools/testing/selftests/ipc/msgque.c
> @@ -193,6 +193,12 @@ int main(int argc, char **argv)
>  	int msg, pid, err;
>  	struct msgque_data msgque;
>  
> +	if (getuid() != 0) {
> +		fprintf(stderr, "Please run the test as root - Exiting.\n");
> +		exit(1);
> +	}

Please use err(3).

> +	printf("Starting ipc tests:\n");

This is unnecessary and adds nothing to the program.

>  	msgque.key = ftok(argv[0], 822155650);
>  	if (msgque.key == -1) {
>  		printf("Can't make key\n");
> @@ -235,6 +241,7 @@ int main(int argc, char **argv)
>  		printf("Failed to test queue\n");
>  		goto err_out;
>  	}
> +	printf("All ipc tests Passsed\n");

So is this.

>  	return 0;
>  
>  err_destroy:


