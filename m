Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3EPSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab3EPSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:25:23 -0400
Date: Thu, 16 May 2013 14:25:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>, netdev@vger.kernel.org,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards
 compatibility
Message-ID: <20130516182510.GA4728@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	netdev@vger.kernel.org,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjørn,

 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1e8bbe6cd02fc300c88bd48244ce61ad9c7d1776
 > Commit:     1e8bbe6cd02fc300c88bd48244ce61ad9c7d1776
 > Parent:     a5b8db91442fce9c9713fcd656c3698f1adde1d6
 > Author:     Bjørn Mork <bjorn@mork.no>
 > AuthorDate: Thu Mar 14 01:05:13 2013 +0000
 > Committer:  David S. Miller <davem@davemloft.net>
 > CommitDate: Sun Mar 17 11:59:03 2013 -0400
 > 
 >     net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility
 >     
 >     commit bd329e1 ("net: cdc_ncm: do not bind to NCM compatible MBIM devices")
 >     introduced a new policy, preferring MBIM for dual NCM/MBIM functions if
 >     the cdc_mbim driver was enabled.  This caused a regression for users
 >     wanting to use NCM.
 >     
 >     Devices implementing NCM backwards compatibility according to section
 >     3.2 of the MBIM v1.0 specification allow either NCM or MBIM on a single
 >     USB function, using different altsettings.  The cdc_ncm and cdc_mbim
 >     drivers will both probe such functions, and must agree on a common
 >     policy for selecting either MBIM or NCM.  Until now, this policy has
 >     been set at build time based on CONFIG_USB_NET_CDC_MBIM.
 >     
 >     Use a module parameter to set the system policy at runtime, allowing the
 >     user to prefer NCM on systems with the cdc_mbim driver.

Is there any way we can set this automatically based on the type of device connected
and have it just work without users needing to edit modprobe.conf ?

Since this change, we've now getting reports like https://bugzilla.redhat.com/show_bug.cgi?id=963663

	Dave

