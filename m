Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaL3DGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:06:34 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35588 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaL3DGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:06:31 -0500
Message-ID: <1419908780.14143.75.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Lang <david@lang.hm>
Cc: Rob Landley <rob@landley.net>, Christophe Fillot <cf@utc.fr>,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 29 Dec 2014 22:06:20 -0500
In-Reply-To: <alpine.DEB.2.02.1412291824550.15184@nftneq.ynat.uz>
References: <5463ABC8.10308@utc.fr>
	 <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <547617AF.6000604@utc.fr>
	 <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5476EBAC.8090103@utc.fr>
	 <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54A1BAEE.6000101@landley.net>
	 <1419889608.14143.40.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.DEB.2.02.1412291824550.15184@nftneq.ynat.uz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123003-4790-0000-0000-000005E1D109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-29 at 18:25 -0800, David Lang wrote: 
> On Mon, 29 Dec 2014, Mimi Zohar wrote:
> 
> > Thanks Rob for the explanation.  The problem is that ramfs does not
> > support extended attributes, while tmpfs does.  The boot loader could
> > "measure" (trusted boot) the initramfs, but as the initramfs is
> > generated on the target system, the initramfs is not signed, preventing
> > it from being appraised (secure Boot). To close the initramfs integrity
> > appraisal gap requires verifying the individual initramfs file
> > signatures, which are stored as extended attributes.
> 
> what's the point of checking the files on the filesystem against signatures 
> stored on the same filesystem? If someone could alter the file contents they can 
> alter the signatures as well.

It's all about limiting which public keys can be used to verify the file
signatures.  As of 3.17, only keys signed by a "trusted" key on the
system keyring may be added to the IMA keyring.

Mimi 

