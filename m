Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaLZDVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 22:21:14 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:42862 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLZDVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 22:21:13 -0500
Message-ID: <549CD425.5020104@hurleysoftware.com>
Date: Thu, 25 Dec 2014 22:21:09 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, jgross@suse.com,
        Thomas Hellstrom <thellstrom@vmware.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION][x86] Commit f5b2831d65 cause boot failure in VMware
 ESXi 5.1 guest
References: <549CC096.3080701@cn.fujitsu.com>
In-Reply-To: <549CC096.3080701@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +to Thomas Hellstrom ]

On 12/25/2014 08:57 PM, Qu Wenruo wrote:
> Hi all,
> 
> When testing v3.19-rc1 kernel(in fact, try to test), the kernel itself fail to boot on VMware ESXi 5.1 guest.

Maybe this problem related to the other VMware PAT issue?

> The boot failure is quite easy to describe, only one line is output:
> "Probing EDD (edd=off to disable)...ok"
> 
> No other output(including warning/bug_on/backtrace or whatever) and the guest just hangs.
> It's OK on v3.18, so it's a regression.
> 
> Bisect points to the following commit:
> commit f5b2831d654167d77da8afbef4d2584897b12d0c
> Author: Juergen Gross <jgross@suse.com>
> Date:   Mon Nov 3 14:02:02 2014 +0100
> 
>     x86: Respect PAT bit when copying pte values between large and normal pages
> 
>     The PAT bit in the ptes is not moved to the correct position when
>     copying page protection attributes between entries of different sized
>     pages. Translate the ptes according to their page size.
> 
> 
> I have also created the kernel BZ report:
> https://bugzilla.kernel.org/show_bug.cgi?id=90321
> 
> Hopes this can be resolved in next rc.
> 
> Thanks,
> Qu

