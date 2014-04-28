Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaD1T6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:58:47 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:54861 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaD1T6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:58:45 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>, Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Thread-Topic: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Thread-Index: AQHPYvpyHrCwing+skK9OYDDStPITZsncA1w
Date: Mon, 28 Apr 2014 19:58:43 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03046D192103@US01WEMBX2.internal.synopsys.com>
References: <20140428204923.GC12185@intel.com>
 <20140428155536.GE30292@saruman.home>
In-Reply-To: <20140428155536.GE30292@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Felipe Balbi
> Sent: Monday, April 28, 2014 8:56 AM
> 
> On Mon, Apr 28, 2014 at 04:49:23PM -0400, Zhuang Jin Can wrote:
> > Adds a debugfs file "snapshot" to dump dwc3 requests, trbs and events.

< snip > 

> > +	for (i = 0; i < evt->length; i += 4) {
> > +		event.raw = *(u32 *) (evt->buf + i);
> > +		if (i == evt->lpos) {
> > +			seq_puts(s, "lpos-------|\n");
> > +			seq_puts(s, "           \\\n");
> > +		}
> > +		seq_printf(s, "event[%d]: %08x ", i, event.raw);
> > +
> > +		if (event.type.is_devspec)
> > +			dwc3_dump_dev_event(s, &event.devt);
> > +		else
> > +			dwc3_dump_ep_event(s, &event.depevt);
> > +		seq_puts(s, "\n");
> > +	}
> 
> how well have you tested this ? I'm not entirely sure you should be
> reading the event buffer at any time you want, though I might be wrong.

Just FYI, it is fine to read from the event buffer memory at any time.
But of course, if you happen to read from a location at the same time
the core is writing to it, you may read either the old value or the new,
depending on the timing. So the results might not be 100% reliable.

-- 
Paul

