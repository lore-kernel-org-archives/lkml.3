Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3EUI3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:29:08 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1865 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab3EUI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:29:04 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <1369124929.29989.0.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Or Gerlitz" <or.gerlitz@gmail.com>
cc: "Eliezer Tamir" <eliezer.tamir@linux.intel.com>,
        "Dave Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        "Willem de Bruijn" <willemb@google.com>,
        "Andi Kleen" <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        "Eliezer Tamir" <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 11:28:49 +0300
In-Reply-To: <CAJZOPZKzTk+zJ2z0Bv9y1iZRdXb842z_WG8E3jNCoHw0C3fhQQ@mail.gmail.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
 <20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
 <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
 <519B1A2B.4010909@linux.intel.com>
 <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
 <CAJZOPZKzTk+zJ2z0Bv9y1iZRdXb842z_WG8E3jNCoHw0C3fhQQ@mail.gmail.com>
Organization: Broadcom
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18)
MIME-Version: 1.0
X-WSS-ID: 7D85F1711R018501373-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 11:21 +0300, Or Gerlitz wrote:
> On Tue, May 21, 2013 at 10:06 AM, Eilon Greenstein <eilong@broadcom.com> wrote:
> > Or - at least for the bnx2x, it is easy to add support for this new ndo.
> 
> Do you understand what's the equivalent of that mysterious module
> param for your driver/HW - or you just copied and pasted that black
> magic code?
> 

The module parameter is not the interesting part of this patch. It is
clear that unloading the module while this sort of traffic is running is
not safe and the alternative of adding a reference count or something
similar sounds too costly (after all, this patch is about performance).
I just played with it to get a feel of the latency improvement - I did
not try unloading the module during traffic so I do not care about the
module parameter part right now. I agree that the unload should be
looked into - but the general concept is great and it is a very nice
improvement.



