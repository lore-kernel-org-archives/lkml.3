Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaEUKxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:53:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61280 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752358AbaEUKxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:53:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Date: Wed, 21 May 2014 13:10:33 +0200
Message-ID: <2394524.GkgpdWbBbP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521085207.GR1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com> <1400136256-2218-10-git-send-email-rui.zhang@intel.com> <20140521085207.GR1651@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2014 11:52:07 AM Mika Westerberg wrote:
> On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
> > For some ACPI device objects, they represent master devices,
> > and their children devices are enumerated by bus controller drivers
> > for the buses they are on.
> > 
> > In this case, we do not want to enumerate their children devices to
> > platform bus explicitly in acpi scan code.
> > 
> > Thus a new flag .is_master_device is introduced in this patch.
> > 
> > For devices with this flag set, we will not do default enumeration
> > for their children.
> 
> Is there any particular reason we would like to enumerate everything
> below the first device by default?

Yes, there is.  Device objects without _ADR under the PCI host bridge.

Or we can skip the children under every *platform* device created by this by
default and mark the ones where we want the children to be enumerated as
platform devices too in a special way if needed.

I guess we could try that (that was the Rui's original idea IIRC).

Rafael

