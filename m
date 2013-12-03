Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3LCLMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:12:08 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:42500 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3LCLMG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 3 Dec 2013 06:12:06 -0500
Message-Id: <529DCA8F02000078001094FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 03 Dec 2013 11:11:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Roger Pau Monne" <roger.pau@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Julien Grall" <julien.grall@linaro.org>,
        <xen-devel@lists.xenproject.org>,
        "BorisOstrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define
 structures in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
 <1386068729.13256.8.camel@kazak.uk.xensource.com>
In-Reply-To: <1386068729.13256.8.camel@kazak.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.12.13 at 12:05, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Tue, 2013-12-03 at 11:57 +0100, Roger Pau Monne wrote:
>> Using __packed__ on the public interface is not correct, this
>> structures should be compiled using the native ABI, and __packed__
>> should only be used in the backend counterpart of those structures
>> (which needs to handle different ABIs).
>> 
>> This was even worse in the ARM case, where the Linux kernel was
>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
>> also breaks compatibility, so an ARM DomU kernel compiled with
>> this patch will fail to communicate with PV disk devices unless the
>> Dom0 also has this patch.
> 
> This is acceptable IMHO, the ARM ABI is clearly defined and previous
> kernels were simply buggy. The fact that front and backend were
> equivalently buggy and so it happened to work is not an excuse.

But afaics the change is not just to the ARM form of the ABI,
but to x86 (32- and 64-bit) too. And that clearly must not be
altered.

Jan

