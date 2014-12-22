Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaLVXCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:02:04 -0500
Received: from p3plsmtpa07-01.prod.phx3.secureserver.net ([173.201.192.230]:39787
	"EHLO p3plsmtpa07-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbaLVXCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:02:01 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 18:02:01 EST
Message-ID: <5498A137.6020707@lurklurk.org>
Date: Mon, 22 Dec 2014 17:54:47 -0500
From: David Drysdale <dmd@lurklurk.org>
Reply-To: David Drysdale <drysdale@google.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, schwab@linux-m68k.org,
        geert@linux-m68k.org
CC: shuahkh@osg.samsung.com, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH selftest fails!] m68k: Wire up execveat
References: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg>	<874msp3w7j.fsf@igel.home> <CAHse=S-KzC5y8eC_ZFrbUJo0Ub5Qv8WeeXHdY1-F=HckAX=L=A@mail.gmail.com>
In-Reply-To: <CAHse=S-KzC5y8eC_ZFrbUJo0Ub5Qv8WeeXHdY1-F=HckAX=L=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-send from a different email address because I apparently can't send 
plaintext from gMail on my phone.]

On 21 Dec 2014 09:37, "Andreas Schwab" <schwab@linux-m68k.org> wrote:
 >
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>  > Check success of execveat(5,
> 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [FAIL] (child 792
> exited with 126 not 127)
>
> POSIX says
> (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08_02):
>
>      If a command is not found, the exit status shall be 127. If the
>      command name is found, but it is not an executable utility, the exit
>      status shall be 126.
>
 > Andreas.
 >

That sounds like a bit of a grey area -- is ENAMETOOLONG nearer to 
ENOENT or EACCES?   Maybe it's best to make the test allow either (given 
that it's not a test of shell behaviour).

I can update the test to do that, but it probably won't be until the new 
year I'm afraid.

David
