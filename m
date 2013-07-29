Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3G2Vsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:48:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59303 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754397Ab3G2Vsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:48:31 -0400
Message-ID: <1375134511.2075.76.camel@joe-AO722>
Subject: Re: Checkpatch error on trace events macros
From: Joe Perches <joe@perches.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jul 2013 14:48:31 -0700
In-Reply-To: <20130729212328.GD14883@xanatos>
References: <20130729195201.GC14883@xanatos>
	 <1375128164.2075.53.camel@joe-AO722> <20130729212328.GD14883@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 14:23 -0700, Sarah Sharp wrote:
> On Mon, Jul 29, 2013 at 01:02:44PM -0700, Joe Perches wrote:
> > On Mon, 2013-07-29 at 12:52 -0700, Sarah Sharp wrote:
[]
> > > sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
> > > Applying: xhci: add traces for debug messages in xhci_address_device()
> > > ERROR: Macros with complex values should be enclosed in parenthesis
> > > #86: FILE: drivers/usb/host/xhci-trace.h:15:
> > > +#define TRACE_SYSTEM xhci-hcd
> > 
> > <shrug>
> > 
> > I think these are suboptimal as the files should use
> > underscores rather than dashes.

It's ~3:2 in favor of _ in the tree.

$ git ls-files | awk -F"/" '{print $NF;}' | grep "-" | wc -l
8078
$ git ls-files | awk -F"/" '{print $NF;}' | grep "_" | wc -l
12577

closer to 1:1 if you include all the directory names too.

$ git ls-files | grep "-" | wc -l
11821
$ git ls-files | grep "_" | wc -l
13005

> The norm in the USB subsystem is to use dashes in filenames.

Not really.

$ git ls-files drivers/usb | awk -F"/" '{print $NF;}' | grep "-" | wc -l
168
$ git ls-files drivers/usb | awk -F"/" '{print $NF;}' | grep "_" | wc -l
177

> there is no "should" here, just opinions.

Given the "I think", we agree!

