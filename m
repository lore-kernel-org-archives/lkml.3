Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaDANTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:19:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDANTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:19:13 -0400
Message-ID: <533ABCCB.4090502@oracle.com>
Date: Tue, 01 Apr 2014 09:19:07 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: liblockdep soname versioning
References: <CA+5PVA67oBeHUiPXj0viNgrX+uDnJ9LsZSPXF1cLt_D511KKtA@mail.gmail.com>
In-Reply-To: <CA+5PVA67oBeHUiPXj0viNgrX+uDnJ9LsZSPXF1cLt_D511KKtA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:56 AM, Josh Boyer wrote:
> Hi Sasha,
>
> We've had a request [1] to package up liblockdep in Fedora.  Looking
> things over, I noticed the library isn't actually versioned at all and
> instead just builds a plain .so file.  That's likely fine during
> development of it, but if distros are to ship it for broader use then
> it would be a good idea to specify the soname and use a versioned .so.
>
> The makefile already has LIBLOCKDEP_VERSION defined.  Would it be
> possible to use this as the soname and version number?  Then
> liblockdep.so could be the normal symlink to the versioned .so
> (liblockdep.so.0.0.1 in this case).
>
> Thanks.
>
> josh
>
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1082763
>

Sure! I never expected it to live outside the kernel tree as a separate
package, but I'm happy to accommodate for that.

I think that I'll just match the version number with the kernel version
since what mostly matters is what you have in kernel/lockdep.c, so for
example, right now we'll have 'liblockdep.so.3.15.0'. Sounds good?


Thanks,
Sasha
