Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3BESes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:34:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab3BESeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:34:44 -0500
Date: Tue, 5 Feb 2013 13:34:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130205183436.GC12853@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205181926.GA13942@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 06:19:26PM +0000, Matthew Garrett wrote:
> On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:
> 
> > Digitally signed initramfs can be used to provide protected user-space
> > environment for initialization purpose. For example, LSM, IMA/EVM can be
> > securely initialized using such approach.
> 
> What stops an attacker from simply removing the signed image from the 
> initramfs and running modified versions of the same tools from the 
> unsigned image?

Looks like having signed initramfs image is mandatory otherwise system
panics.

+	if (sys_access(initramfs_img, 0))
+               panic("signed initramfs image not found (INITRAMFS_SIG is
+anabled)\n");

Also I am assuming that from signed initramfs, keys will be loaded in
appropriate keyrings and then keyring will be locked so that any 
tools from unsigned initramfs can not load additional keys.

Thanks
Vivek
