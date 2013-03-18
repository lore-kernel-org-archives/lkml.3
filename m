Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3CRWEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:04:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab3CRWEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:04:32 -0400
Date: Mon, 18 Mar 2013 23:04:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Yinghai Lu <yinghai@kernel.org>, Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <20130318191903.GS9021@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1303182301450.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz> <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz> <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz> <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com> <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
 <20130318191903.GS9021@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Daniel Vetter wrote:

> Yep, there's a big comment in the irq handler for that chipset that we
> have a gaping race with when using MSI interrupts. Although the comment
> bodly claims that the race is small enough to avoid the dreaded "nobody
> cared" message. Looks like gmbus is good at hitting that race - on newer
> chips it already brought up a similar race in handling pch interrupts.

I see ... will target my focus in that direction, thanks.

> Can you please give the below patch a whirl? It removes the probably race
> msi race avoidance code and replaces it with the same trick Paulo used to
> fix pch irq handling races.

Unfortunately it didn't change anything, the spurious interrupt report is 
still there.

-- 
Jiri Kosina
SUSE Labs
