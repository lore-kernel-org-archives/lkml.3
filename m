Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaKXOvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:51:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaKXOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:51:13 -0500
Date: Mon, 24 Nov 2014 09:51:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, xen-devel <xen-devel@lists.xenproject.org>,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: drop SR-IOV VFs when PF driver unloads
Message-ID: <20141124145106.GC3000@laptop.dumpdata.com>
References: <545B9C5F020000780004561B@mail.emea.novell.com>
 <20141121220338.GA17981@laptop.dumpdata.com>
 <5472F22B020000780004A28C@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5472F22B020000780004A28C@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:54:03AM +0000, Jan Beulich wrote:
> >>> On 21.11.14 at 23:03, <konrad.wilk@oracle.com> wrote:
> > I rewrote it a bit to be more in the style of pciback:
> >[...]
> > [v2: Removed the switch statement, moved it about]
> 
> What you don't mention here is that you also removed the outer
> loop, yet that breaks functionality afaict: There can (and I suppose
> normally will) be multiple VFs needing device_release_driver() called
> when a single PF goes away.

Good point.
> 
> Also I'm not really happy for a patch with my S-o-b underneath to
> introduce goto-s without real need.

Will ditch them.
> 
> Jan
> 
