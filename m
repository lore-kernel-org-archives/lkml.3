Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3BUJeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:34:50 -0500
Received: from multi.imgtec.com ([194.200.65.239]:12602 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3BUJes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:34:48 -0500
Message-ID: <5125EA35.7060602@imgtec.com>
Date: Thu, 21 Feb 2013 09:34:45 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] metag: copy devicetree to non-init memory
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com> <1361371929-28148-2-git-send-email-james.hogan@imgtec.com> <5125E3F2.7070402@synopsys.com>
In-Reply-To: <5125E3F2.7070402@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_21_09_34_46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On 21/02/13 09:08, Vineet Gupta wrote:
> On Wednesday 20 February 2013 08:22 PM, James Hogan wrote:
>> Make a copy of the device tree blob in non-init memory. It is required
>> when using built-in device tree files that the platform code copies the
>> blob to non-init memory prior to calling unflatten_device_tree(),
>> otherwise the strings that the device tree refer to will get poisoned
>> and potentially reused, breaking later reading of the device tree
>> post-init (such as compatible matching in modules, debugfs, and the
>> procfs interface).
> 
> While the patch conceptually looks correct, I'm not sure why any user of DT -
> post-init would refer to DT bindings using of_fdt_* API which use the flat tree,
> instead of the binary tree (more efficient in space/usage). Is this to support
> some in-transition drivers and other code.

The strings aren't copied when the devicetree is unflattened, so the
unflattened version still points into initdata, so all the strings "in"
the unflattened version are wiped when it's freed too.

Documentation/kbuild/makefiles.txt has this to say:
>     dtc
> 	Create flattend device tree blob object suitable for linking
> 	into vmlinux. Device tree blobs linked into vmlinux are placed
> 	in an init section in the image. Platform code *must* copy the
> 	blob to non-init memory prior to calling unflatten_device_tree().

Other architectures using the builtin dtb also do the copy. I presume
it's in initdata in the first place to avoid keeping the built-in one
around if one is provided by the bootloader instead.

Cheers
James

