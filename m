Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3JIRjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:39:03 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33719 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3JIRjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:39:00 -0400
Date: Wed, 9 Oct 2013 11:38:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Fuchs, Andreas" <andreas.fuchs@sit.fraunhofer.de>
Cc: Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [TrouSerS-tech] [tpmdd-devel] [PATCH 09/13] tpm: Pull everything
 related to sysfs into tpm-sysfs.c
Message-ID: <20131009173847.GC18899@obsidianresearch.com>
References: <5240A2A3.4040102@tycho.nsa.gov>
 <20130923204232.GB16345@obsidianresearch.com>
 <5240BA0E.3000304@tycho.nsa.gov>
 <20130923222324.GA9533@obsidianresearch.com>
 <5241A199.1080505@tycho.nsa.gov>
 <20130930181005.GG28898@obsidianresearch.com>
 <5249E0CB.2070106@tycho.nsa.gov>
 <5249F6AF.7050608@linux.vnet.ibm.com>
 <20131004170803.GB6955@obsidianresearch.com>
 <9F48E1A823B03B4790B7E6E69430724D2E99F4E9@EXCH2010A.sit.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724D2E99F4E9@EXCH2010A.sit.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:15:55AM +0000, Fuchs, Andreas wrote:


> Rather than an ioctl, why not provide a different tpm-device per
> locality. This way, the access to the different localities can be
> restricted via standard user/group of the device.  i.e. /dev/tpm0l1,
> /dev/tpm0l2, ... or similar approaches...

The way the TPM architecture is setup you will need the middle ware to
do the switching between localities and managing cross locality
resources, so it doesn't make sense for the kernel to export a
locality specific char device.

You'd have to do the above by having trousers create unix domain
sockets for each of the privilege levels and using the usual security
mechanisms to protect access to those sockets.

Jason
