Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaBQQ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:58:07 -0500
Received: from relay.parallels.com ([195.214.232.42]:41161 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaBQQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:58:01 -0500
Message-ID: <53023F8D.4090304@parallels.com>
Date: Mon, 17 Feb 2014 20:57:49 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Vagin <avagin@gmail.com>, Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries
 of data, brk and stack
References: <1392387209-330-1-git-send-email-avagin@openvz.org> <1392387209-330-2-git-send-email-avagin@openvz.org> <874n41znl5.fsf@xmission.com> <20140214174314.GA5518@gmail.com> <20140214180129.GK13358@moon> <8761ohqzc6.fsf@xmission.com> <52FE72C1.9090100@parallels.com> <87txc1pibc.fsf@xmission.com> <5301C984.40904@parallels.com> <20140217085241.GR13358@moon>
In-Reply-To: <20140217085241.GR13358@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 12:52 PM, Cyrill Gorcunov wrote:
> On Mon, Feb 17, 2014 at 12:34:12PM +0400, Pavel Emelyanov wrote:
> ...
>> Maybe we can make prlctl() do lite-execve()? It will open the executable, read the
>> required amount of headers and just put data red from there onto mm-struct? This 
>> should be MUCH better, that full execve() with loading all binary data plus strace
>> and flushing old mm-s.
> 
> Well, this would be good, except I don't know how would we deal with executables
> which are running but deleted, where would we fetch these headers from? (Note the
> program can map new executable region, jump there and unmap own text section).

If we meet opened but unlinked file we handle this by either carrying the file
with us, or by creating a hard-link when possible. Anyway, this is not a problem,
we can handle this.

As far as unmapped .text section is concerned. It also doesn't matter much. I we
agree on API that doesn't flush old mappings (I really hope we do), we will be
able to remap them as needed.

Thanks,
Pavel
