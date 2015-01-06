Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbbAFIxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:53:22 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:45632 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbAFIxS (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 6 Jan 2015 03:53:18 -0500
Message-Id: <54ABA27C02000078000C4D65@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 06 Jan 2015 08:53:16 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: xen/x86: properly retrieve NMI reason
References: <54945D760200007800051157@mail.emea.novell.com>
 <54AA68D8.7050400@citrix.com>
In-Reply-To: <54AA68D8.7050400@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> David Vrabel <david.vrabel@citrix.com> 01/05/15 11:35 AM >>>
>On 19/12/14 16:16, Jan Beulich wrote:
>> Using the native code here can't work properly, as the hypervisor would
>> normally have cleared the two reason bits by the time Dom0 gets to see
>> the NMI (if passed to it at all). There's a shared info field for this,
>> and there's an existing hook to use - just fit the two together. Note
>> that the hook can (and should) be used irrespective of whether being in
>> Dom0, as accessing port 0x61 in a DomU would be even worse, while the
>> shared info field would just hold zero all the time.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>
>This doesn't build.
>
>In file included from
>/local/davidvr/work/k.org/tip/arch/x86/xen/enlighten.c:43:0:
>/local/davidvr/work/k.org/tip/include/xen/interface/nmi.h:44:1: warning:
>data definition has no type or storage class [enabled by default]
>/local/davidvr/work/k.org/tip/include/xen/interface/nmi.h:44:1: error:
>type defaults to ‘int’ in declaration of ‘DEFINE_XEN_GUEST_HANDLE’
>[-Werror=implicit-int]
>cc1: some warnings being treated as errors

Hmm, I can see why this happens (Linux renaming the macro from what
the canonical headers use), but I'll have to check why my build test didn't
catch this...

Jan

