Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaCEQlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:41:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59171 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaCEQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:41:48 -0500
Message-ID: <5317538D.9060302@zytor.com>
Date: Wed, 05 Mar 2014 08:40:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-9-git-send-email-vgoyal@redhat.com> <20140227213629.GP18191@pd.tnic> <20140228163134.GG28744@redhat.com> <20140305163722.GC28317@pd.tnic>
In-Reply-To: <20140305163722.GC28317@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 08:37 AM, Borislav Petkov wrote:
>>
>> If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
>> the boot protocol version is "old".  Loading an old kernel, the
>> following parameters should be assumed:
>>
>>         Image type = zImage
>>         initrd not supported
>>         Real-mode kernel must be located at 0x90000.
>>
>> So if it is old version then it is zImage (and not bzImage). So pr_debug()
>> message seems to be correct that image one is trying to load is not
>> bzImage and this loader will not handle this image.
> 
> Ok, old == zImage, got it.
> 

No, old ⊂ zImage, but you can have a zImage with a newer protocol
version, too.  There are no load flags in the old protocol.

These days the old protocol is interesting mostly because of non-Linux
images using the same boot protocol.

	-hpa

