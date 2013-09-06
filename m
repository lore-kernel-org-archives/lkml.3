Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3IFOtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:49:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38999 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3IFOtG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Sep 2013 10:49:06 -0400
Message-Id: <522A078902000078000F11F9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 06 Sep 2013 15:49:13 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/p2m: Export set_phys_to_machine.
References: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
 <5229FD6A02000078000F119C@nat28.tlf.novell.com>
 <20130906143909.GC5140@phenom.dumpdata.com>
In-Reply-To: <20130906143909.GC5140@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.13 at 16:39, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Fri, Sep 06, 2013 at 03:06:02PM +0100, Jan Beulich wrote:
>> >>> On 06.09.13 at 16:00, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > We have already exported 'get_phys_to_machine' and there are
>> > third-party drivers that depend on this other symbol. As such
>> > lets make this balanced and also export this symbol.
>> 
>> I tend to disagree: Allowing external modules read access to some
>> internal state is quite different from also allowing them to alter it.
> 
> I am not following you. We have drivers in the kernel that do
> this now. For example xen-netfront uses set_phys_to_machine.

In which case exporting it would be fine (and necessary). But you
explicitly said "third-party drivers".

> Oddly it can be built as a module.  I am wondering how it actually
> works without this EXPORT symbol.

See the early return in xennet_release_rx_bufs() - the use of
the symbol is in dead code.

Jan

