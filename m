Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3KMG3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:29:06 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:62846 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab3KMG3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:29:02 -0500
X-AuditID: 12074425-b7fd96d000000c39-42-52831c2dfad1
Date: Wed, 13 Nov 2013 01:28:57 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113062857.GB8043@ringworld.MIT.EDU>
References: <52830546.8010002@zytor.com>
 <20131113042303.GY8043@ringworld.MIT.EDU>
 <20131113060807.GA11394@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113060807.GA11394@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsUixG6noqsr0xxksGabhMW0jeIWu+csZrG4
	vGsOmwOzx5kFR9g9Pm+S8zjR8oU1gDmKyyYlNSezLLVI3y6BK2PtnX7Wgn6Oij2XnBsYN7N1
	MXJySAiYSMycvokdwhaTuHBvPVCci0NIYDaTxO6zV1khnI2MEo/+T2GGcH4xSnzbcB+snUVA
	VWLx3w9g7WwCChI/5q8DKxIR6GaUWHf3LVhCWMBAYtfOLhYQm1fAVGLxuy9gzUIClRITvz+C
	igtKnJz5BMxmFtCSuPHvJVMXIweQLS2x/B8HSJhTQF9i8a8jYCWiAioSU05uY5vAKDALSfcs
	JN2zELoXMDKvYpRNya3SzU3MzClOTdYtTk7My0st0rXQy80s0UtNKd3ECA5bF9UdjBMOKR1i
	FOBgVOLhtYhpChJiTSwrrsw9xCjJwaQkyntGpDlIiC8pP6UyI7E4I76oNCe1+BCjBAezkgjv
	AWGgHG9KYmVValE+TEqag0VJnPcWh32QkEB6YklqdmpqQWoRTFaGg0NJgjdNGqhRsCg1PbUi
	LTOnBCHNxMEJMpwHaDgfSA1vcUFibnFmOkT+FKOilDjvVSmghABIIqM0D64XllZeMYoDvSLM
	2wHSzgNMSXDdr4AGMwENtihuAhlckoiQkmpgXHz3RlHiruObW2MXWAZHxT67l6g2w++hwy3m
	3a5nmHYbbPt8MVFS/kpY4bRmjgkvFLMPvGDPPX7n64eD766urjjgayf473txbGVElfb8m69f
	XV/wxmeGwPrpMg2HM9fuPHN5qsp6dbukzYeFr7Nnnvjy89wq65/2LgyHi7Z1f/9lb5acnG51
	qVSJpTgj0VCLuag4EQAMRHekBgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:08:07AM -0500, Theodore Ts'o wrote:
> On Tue, Nov 12, 2013 at 11:23:03PM -0500, Greg Price wrote:
> > That's a good idea.  I've worried about the same thing, but hadn't
> > thought of that solution.
> 
> I think the key is that we set a default of requiring 128 bits, or 5
> minutes, with boot-line options to change the defaults.  BTW, with the
> changes that are scheduled for 3.13, this shouldn't be a problem on
> most desktops.  From my T430s laptop: [...]
> 
> So even without adding device attach times (which is on the todo list)
> the /dev/urandom pool is getting an estimated 128 bits of entropy
> almost two seconds *before* the root file system is remouted
> read/write.

Great!


> This is why I've been working improving the random driver's efficiency
> in getting the urandom pool as soon as possible, as higher priority
> than adding blocking-on-boot for /dev/urandom.

Makes sense.  Blocking on boot is only sustainable anyway if it rarely
lasts past early boot.

Greg
