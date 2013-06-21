Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423243Ab3FUPZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:25:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57312 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161369Ab3FUPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:25:48 -0400
Message-ID: <1371828346.3040.3.camel@dabdike>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>
Date: Fri, 21 Jun 2013 08:25:46 -0700
In-Reply-To: <51C3A489.1050905@intel.com>
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com>
	 <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org>
	 <51C02571.3090100@intel.com> <51C26861.9050106@intel.com>
	 <51C2E12F.4000603@cogentembedded.com> <51C3A489.1050905@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 08:55 +0800, Aaron Lu wrote:
> On 06/20/2013 07:02 PM, Sergei Shtylyov wrote:
> > Hello.
> 
> Hi,
> 
> Thanks for your comments.
> 
> > 
> > On 20-06-2013 6:26, Aaron Lu wrote:
> >>
> >> +void ata_acpi_hotplug_init(struct ata_host *host)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < host->n_ports; i++) {
> >> +		struct ata_port *ap = host->ports[i];
> >> +		acpi_handle handle;
> >> +		struct ata_device *dev;
> >> +
> >> +		if (!ap)
> >> +			continue;
> >> +
> >> +		handle = ata_ap_acpi_handle(ap);
> >> +		if (handle) {
> >> +			/* we might be on a docking station */
> >> +			register_hotplug_dock_device(handle,
> >> +					&ata_acpi_ap_dock_ops, ap);
> > 
> >     Please indent this line under the next character after ( above.
> 
> Is there a link about this rule? I might have missed something about
> coding style.

The rule is follow the coding style in the file, unless there's
something really wrong with it (which there might be in the case of
really old drivers).  The reason is that a mixture of coding styles
makes the file much harder to read than a single consistent style.

In this case, if you look at libata-acpi.c you see all continuation
lines of function calls are aligned with open braces.

James


