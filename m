Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaLAS46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:56:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:20514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaLAS44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:56:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="423666549"
From: "Fujinaka, Todd" <todd.fujinaka@intel.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC: Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Hisashi T Fujinaka <htodd@twofifty.com>,
        "Vick, Matthew" <matthew.vick@intel.com>,
        "Greg@isotope.jf.intel.com" <Greg@isotope.jf.intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "John@isotope.jf.intel.com" <John@isotope.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [linux-nics] [PATCH] e1000: remove unused variables
Thread-Topic: [linux-nics] [PATCH] e1000: remove unused variables
Thread-Index: AQHQDSMdIHw65NF/BkSlcmAo5eu6OZx7Fidw
Date: Mon, 1 Dec 2014 18:56:46 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD653454C69@ORSMSX114.amr.corp.intel.com>
References: <1417065728-5592-1-git-send-email-sudipm.mukherjee@gmail.com>
	<alpine.NEB.2.11.1411262157110.1481@chris.i8u.org>
	<1417311913.7215.111.camel@decadent.org.uk> <20141201045446.GA3277@sudip-PC>
In-Reply-To: <20141201045446.GA3277@sudip-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussing this locally, I'd like to NAK it because this could cause regressions to parts that are still in use but we don't have access to. Also, the assignment was necessary in the past for some versions of gcc and since this may be used in embedded systems using older compilers, we should leave it be.

Thanks.

Todd Fujinaka
Software Application Engineer
Networking Division (ND)
Intel Corporation
todd.fujinaka@intel.com
(503) 712-4565

-----Original Message-----
From: linux-nics-bounces@isotope.jf.intel.com [mailto:linux-nics-bounces@isotope.jf.intel.com] On Behalf Of Sudip Mukherjee
Sent: Sunday, November 30, 2014 8:55 PM
To: Ben Hutchings
Cc: Linux NICS; e1000-devel@lists.sourceforge.net; Hisashi T Fujinaka; Vick, Matthew; Greg@isotope.jf.intel.com; Kirsher, Jeffrey T; netdev@vger.kernel.org; Wyborny, Carolyn; John@isotope.jf.intel.com; linux-kernel@vger.kernel.org
Subject: Re: [linux-nics] [PATCH] e1000: remove unused variables

On Sun, Nov 30, 2014 at 01:45:13AM +0000, Ben Hutchings wrote:
> On Wed, 2014-11-26 at 21:59 -0800, Hisashi T Fujinaka wrote:
> > I'm pretty sure those double reads are there for a reason, so most 
> > of this I'm going to have to check on Monday. We have a long holiday 
> > weekend here in the US.
> [...]
> 
> If there were double register reads being replaced with single 
> register reads, I'd agree this was likely to introduce a regression.  
> But all I see is var = er32(REG) being changed to er32(REG).

no, double register reads are not modified. only the unused variables are removed.

thanks
sudip

> 
> Ben.
> 
> --
> Ben Hutchings
> The world is coming to an end.	Please log off.


_______________________________________________
Linux-nics mailing list
Linux-nics@intel.com
