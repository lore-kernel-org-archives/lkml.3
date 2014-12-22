Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaLVSOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:14:11 -0500
Received: from lists.s-osg.org ([54.187.51.154]:41518 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaLVSOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:14:09 -0500
Message-ID: <54985F6E.2010205@osg.samsung.com>
Date: Mon, 22 Dec 2014 11:14:06 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Drysdale <drysdale@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/exec: Use %zu to format size_t
References: <1419159496-11558-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1419159496-11558-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2014 03:58 AM, Geert Uytterhoeven wrote:
> On 32-bit:
> 
> execveat.c: In function 'check_execveat_pathmax':
> execveat.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
> execveat.c:187: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index 33a5c06d95caa038..d273624c93a64254 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -179,11 +179,11 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
>  	 */
>  	fd = open(longpath, O_RDONLY);
>  	if (fd > 0) {
> -		printf("Invoke copy of '%s' via filename of length %lu:\n",
> +		printf("Invoke copy of '%s' via filename of length %zu:\n",
>  			src, strlen(longpath));
>  		fail += check_execveat(fd, "", AT_EMPTY_PATH);
>  	} else {
> -		printf("Failed to open length %lu filename, errno=%d (%s)\n",
> +		printf("Failed to open length %zu filename, errno=%d (%s)\n",
>  			strlen(longpath), errno, strerror(errno));
>  		fail++;
>  	}
> 


Applied to kernel/git/shuah/linux-kselftest.git fixes
for 3.19-rc2

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
