Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaIUMt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 08:49:29 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:37863 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbaIUMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 08:49:13 -0400
X-RRZE-Submit-IP: 2001:a60:f0c5:0:16da:e9ff:feee:da1
Date: Sun, 21 Sep 2014 14:42:46 +0200
From: Dominik Paulus <dominik.paulus@fau.de>
To: Max Vozeler <max@hinterhof.net>
Cc: Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@vger.kernel.org, valentina.manea.m@gmail.com,
        shuah.kh@samsung.com, gregkh@linuxfoundation.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Subject: Re: [PATCH 03/18] usbip: Add kernel support for client ACLs
Message-ID: <20140921124246.GA2097@d-paulus.de>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
 <1410910735-27929-4-git-send-email-maximilian@eschenbacher.email>
 <20140921004433.GA12922@x201t.vpn.hinterhof.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921004433.GA12922@x201t.vpn.hinterhof.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 02:44:33AM +0200, Max Vozeler wrote:
> Hi,
> 
> On Tue, Sep 16, 2014 at 11:38:40PM +0000, Maximilian Eschenbacher wrote:
> > From: Dominik Paulus <dominik.paulus@fau.de>
> > 
> > This patch adds the possibility to stored ACLs for allowed clients for
> > each stub device in sysfs. It adds a new sysfs entry called "usbip_acl"
> > for each stub device, containing a list of CIDR masks of allowed
> > clients. This file will be used by usbip and usbipd to store the ACL.
> 
> Is there a need to involve the kernel here, couldn't usbip and usbipd
> apply the ACLs during connection setup in userspace?

In fact, they do, sysfs is just used for storing the ACLs. They are
never interpreted by the kernel. Admittedly, this isn't great design,
but currently, the ACLs are specified when binding a device to usbip
using the "usbip bind" utility and interpreted by usbipd when a
connection attempt is made. usbip (configuration utility) and usbipd
(userspace daemon) don't communicate in userspace at all, and moving the
ACLs out of kernel would be considerably more code and more error prone.

Regards,
Dominik
