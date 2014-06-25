Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaFYUWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:22:17 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:10554 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaFYUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:22:13 -0400
Message-ID: <1403727729.2581.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] tools: msgque improve error handling when not running
 as root
From: Davidlohr Bueso <davidlohr@hp.com>
To: shuah.kh@samsung.com
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        colin.king@canonical.com, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 13:22:09 -0700
In-Reply-To: <53AB2DE4.8030804@samsung.com>
References: <1403725210-10245-1-git-send-email-shuah.kh@samsung.com>
	 <1403726744.2581.3.camel@buesod1.americas.hpqcorp.net>
	 <53AB2DE4.8030804@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 14:15 -0600, Shuah Khan wrote:
> On 06/25/2014 02:05 PM, Davidlohr Bueso wrote:
> > On Wed, 2014-06-25 at 13:40 -0600, Shuah Khan wrote:
> >> The test fails in the middle when it is not run as root while
> >> accessing /proc/sys/kernel/msg_next_id. Changed it to check
> >> for root at the beginning of the test. Also added messages
> >> to indicate start and test pass status.
> >>
> >> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> >> ---
> >>   tools/testing/selftests/ipc/msgque.c | 7 +++++++
> >>   1 file changed, 7 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
> >> index aa290c0..30c627a 100644
> >> --- a/tools/testing/selftests/ipc/msgque.c
> >> +++ b/tools/testing/selftests/ipc/msgque.c
> >> @@ -193,6 +193,12 @@ int main(int argc, char **argv)
> >>   	int msg, pid, err;
> >>   	struct msgque_data msgque;
> >>
> >> +	if (getuid() != 0) {
> >> +		fprintf(stderr, "Please run the test as root - Exiting.\n");
> >> +		exit(1);
> >> +	}
> >
> > Please use err(3).
> 
> I will make this printf to be consistent with the rest of the
> printfs in this file.

Can you please update the file then. err(EXIT_FAILURE, ...) is a lot
nicer than fprintf+exit combos all over the place.

> 
> >
> >> +	printf("Starting ipc tests:\n");
> >
> > This is unnecessary and adds nothing to the program.
> 
> The reason for doing this is it becomes easier to parse when this test
> is run as part of run_tests at the top level:

Parsing reasons should not determine such things. What if I add shm, or
semaphore tests to the ipc dir?? Then the text would be bogus. What if
not all tests pass? There is no way of determining a percentage of
completeness. Please do not add such things for a simple msg queue
program as it doesn't necessarily represent ipc selftests.

