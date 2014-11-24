Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaKXHyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:54:10 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:54220 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaKXHyI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 24 Nov 2014 02:54:08 -0500
Message-Id: <5472F22B020000780004A28C@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 24 Nov 2014 07:54:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-pciback: drop SR-IOV VFs when PF driver
 unloads
References: <545B9C5F020000780004561B@mail.emea.novell.com>
 <20141121220338.GA17981@laptop.dumpdata.com>
In-Reply-To: <20141121220338.GA17981@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.11.14 at 23:03, <konrad.wilk@oracle.com> wrote:
> I rewrote it a bit to be more in the style of pciback:
>[...]
> [v2: Removed the switch statement, moved it about]

What you don't mention here is that you also removed the outer
loop, yet that breaks functionality afaict: There can (and I suppose
normally will) be multiple VFs needing device_release_driver() called
when a single PF goes away.

Also I'm not really happy for a patch with my S-o-b underneath to
introduce goto-s without real need.

Jan

