Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHQMft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 08:35:49 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:46392 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaHQMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 08:35:46 -0400
In-Reply-To: <20140813121550.GA21026@redhat.com>
References: <1407659404-razya@il.ibm.com> <20140810083035.0CF58380729@moren.haifa.ibm.com> <20140810194559.GA4344@redhat.com> <20140811.124621.576073630604147753.davem@davemloft.net> <20140812091850.GD6440@redhat.com> <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com> <20140813121550.GA21026@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        David Miller <davem@davemloft.net>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, kvm-owner@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] vhost: Add polling mode
X-KeepSent: FB3DD9F0:3A92A6A0-C2257D37:0043D722;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1SHF211 December 19, 2013
From: Razya Ladelsky <RAZYA@il.ibm.com>
Message-ID: <OFFB3DD9F0.3A92A6A0-ONC2257D37.0043D722-C2257D37.004522A0@il.ibm.com>
Date: Sun, 17 Aug 2014 15:35:39 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 17/08/2014 15:35:39,
	Serialize complete at 17/08/2014 15:35:39
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081712-4966-0000-0000-0000010B6F0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Hi Michael,
> > 
> > Sorry for the delay, had some problems with my mailbox, and I realized 

> > just now that 
> > my reply wasn't sent.
> > The vm indeed ALWAYS utilized 100% cpu, whether polling was enabled or 

> > not.
> > The vhost thread utilized less than 100% (of the other cpu) when 
polling 
> > was disabled.
> > Enabling polling increased its utilization to 100% (in which case both 

> > cpus were 100% utilized). 
> 
> Hmm this means the testing wasn't successful then, as you said:
> 
>    The idea was to get it 100% loaded, so we can see that the polling is
>    getting it to produce higher throughput.
> 
> in fact here you are producing more throughput but spending more power
> to produce it, which can have any number of explanations besides polling
> improving the efficiency. For example, increasing system load might
> disable host power management.
>

Hi Michael,
I re-ran the tests, this time with the  "turbo mode" and  "C-states" 
features off.
No Polling:
1 VM running netperf (msg size 64B): 1107 Mbits/sec
 Polling:
1 VM running netperf (msg size 64B): 1572 Mbits/sec








As you can see from the new results, the numbers are lower, 
but relatively (polling on/off) there's no change.
Thank you,
Razya


 


 
> 
> > > -- 
> > > MST
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

