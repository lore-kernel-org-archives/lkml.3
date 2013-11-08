Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3KHIGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:06:07 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751095Ab3KHIGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:06:03 -0500
Message-ID: <527C9B5C.6040509@nod.at>
Date: Fri, 08 Nov 2013 09:05:48 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, matthew.garrett@nebula.com, jlee@suse.com
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
References: <527C93B5.7010407@jp.fujitsu.com>
In-Reply-To: <527C93B5.7010407@jp.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.11.2013 08:33, schrieb Yasuaki Ishimatsu:
> By following works, my system very often fails set_variable() to set new
> variable to efi variable storage and shows "efivars: set_variable() failed:
> status=-28" message.
> 
> - commit 31ff2f20d9003e74991d135f56e503fe776c127c
>     efi: Distinguish between "remaining space" and actually used space
> - commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
>     x86,efi: Implement efi_no_storage_paranoia parameter
> - commit f8b8404337de4e2466e2e1139ea68b1f8295974f
>     Modify UEFI anti-bricking code
> 
> When booting my system, remaining space of efi variable storage is about
> 5KB. So there is no room that sets a new variable to the storage.
> 
> According to above works, efi_no_storage_paranoia parameter was prepared
> for sane UEFI which can do gc and fulfills spec. But why need a system
> with a sane UEFI set the parameter? It is wrong. A system with a broken
> UEFI should set the parameter.

And how does one know that his UEFI is broken?
"Oh my board is briked because I wrote too much into a variable, maybe setting
efi_storage_paranoia would have saved me. Let's try with the next board..." ;)

Thanks,
//richard
