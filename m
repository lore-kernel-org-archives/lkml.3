Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab3GQRsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:48:36 -0400
Received: from [157.55.158.23] ([157.55.158.23]:19884 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab3GQRsf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:48:35 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Pravin Shelar <pshelar@nicira.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "ben.howard@canonical.com" <ben.howard@canonical.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, KY Srinivasan <kys@microsoft.com>
Subject: RE: [Regression][v3.10][v3.11] net: Kill link between CSUM and SG
 features.
Thread-Topic: [Regression][v3.10][v3.11] net: Kill link between CSUM and SG
 features.
Thread-Index: AQHOgk+93a9lT4h1pki8hNNxKfqJ+5loFY0AgAAXiQCAAA/ugIABOPcA//+vCaA=
Date: Wed, 17 Jul 2013 17:45:51 +0000
Message-ID: <9d96a2fb07b9474b927f6f4538a0845e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <51E58C45.1080708@canonical.com>
 <CALnjE+oCeo=T+F3BvTBtcV7oDMPLJAEz1p1sjRGxmE8Wq8gWAg@mail.gmail.com>
 <51E5A4CA.20902@canonical.com>
 <CALnjE+rhvmYPEXv=1F1HEe3VsgCNN1SKg5UwTuFatQUm9e9S2w@mail.gmail.com>
 <51E6B8B0.2080103@canonical.com>
In-Reply-To: <51E6B8B0.2080103@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(24454002)(164054003)(199002)(51914003)(189002)(377454003)(479174003)(13464003)(51704005)(66066001)(65816001)(80022001)(54316002)(51856001)(74366001)(56776001)(59766001)(81342001)(54356001)(77982001)(44976005)(6806004)(77096001)(76786001)(83322001)(83072001)(56816003)(76796001)(15202345003)(81542001)(47736001)(50466002)(33646001)(23726002)(50986001)(49866001)(47976001)(79102001)(74706001)(4396001)(16406001)(46102001)(74502001)(47446002)(74662001)(31966008)(76482001)(47776003)(63696002)(53806001)(74876001)(46406003)(20776003)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB604;H:hybrid.exchange.microsoft.com;CLIP:131.107.1.17;RD:mail1.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0910AAF391
X-OriginatorOrg: DuplicateDomain-b1291ffc-369c-4c2a-9225-e2908f70a426.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
> Sent: Wednesday, July 17, 2013 8:31 AM
> To: Pravin Shelar
> Cc: davem@davemloft.net; ben.howard@canonical.com;
> edumazet@google.com; xiyou.wangcong@gmail.com;
> alexander.h.duyck@intel.com; jiri@resnulli.us; netdev@vger.kernel.org;
> LKML; KY Srinivasan; Haiyang Zhang
> Subject: Re: [Regression][v3.10][v3.11] net: Kill link between CSUM and SG
> features.
> 
> On 07/16/2013 04:50 PM, Pravin Shelar wrote:
> > On Tue, Jul 16, 2013 at 12:53 PM, Joseph Salisbury
> > <joseph.salisbury@canonical.com> wrote:
> >> On 07/16/2013 02:29 PM, Pravin Shelar wrote:
> >>> On Tue, Jul 16, 2013 at 11:09 AM, Joseph Salisbury
> >>> <joseph.salisbury@canonical.com> wrote:
> >>>> Hi Pravin,
> >>>>
> >>>> A bug was opened against the Ubuntu kernel[0].  After a kernel
> >>>> bisect, it was found that reverting the following commit resolved this
> bug:
> >>>>
> >>>> commit ec5f061564238892005257c83565a0b58ec79295
> >>>> Author: Pravin B Shelar <pshelar@nicira.com>
> >>>> Date:   Thu Mar 7 09:28:01 2013 +0000
> >>>>
> >>>>     net: Kill link between CSUM and SG features.
> >>>>
> >>>>
> >>>> The regression was introduced as of v3.10-rc1.
> >>>>
> >>>> I see that you are the author of this patch, so I wanted to run
> >>>> this by you.  I was thinking of requesting a revert for v3.11, but
> >>>> I wanted to get your feedback first.
> >>>>
> >>>>
> >>> This issue was reported before and turning off sg solves problem for
> >>> HyperV driver. Drivers (intel and bnx2x) that I tested works fine
> >>> with this patch. Have you seen the issue on any other NIC?
> >> Thanks for the feedback.  We have only seen it on Intel hardware.
> >> Can you send a pointer to the patch? If so, we can provide some
> >> additional testing.  Do you plan on submitting the patch for inclusion in
> 3.11?
> >>
> >>
> > What I mean is I do not see any problem with the patch that you have
> > pointed out on ixgbe and bnx2x platforms. HyperV problem went away
> > with disabling sg by ethtool utility.
> Yes, we also see that the problem goes away when disabling sg with ethtool.
> There was a significant improvement in throughput with sg enabled, so it's
> unfortunate it must be disabled.
> 
> >
> > Can you also give me more information about regression you are seeing
> > like driver name, features of the NIC set and features of device
> > without this patch. Does any other NIC than HyperV having this issue?
> 
> Some details info about the HyperV guest can be seen here:
> http://paste.ubuntu.com/5884549/
> 
> In that output, you will see that scatter-gather is off, which was done
> manually.
> 
> Only a HyperV NIC is having this issue.
I have submitted a patch which has been accepted, and queued for -stable branch
as well: http://patchwork.ozlabs.org/patch/259596/
It removes the NETIF_F_SG flag from the hv_netvsc driver, which doesn't currently
support SG mode.

Thanks,
- Haiyang

