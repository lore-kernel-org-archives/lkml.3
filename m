Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaCTLsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:48:18 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:47311 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757687AbaCTLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:48:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:1963:2393:2525:2553:2560:2563:2682:2685:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7514:7652:8603:9025:9389:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12679:12740:13069:13180:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netchec
X-HE-Tag: room01_d6cc64356d4d
X-Filterd-Recvd-Size: 2031
Message-ID: <1395316090.7776.24.camel@joe-AO722>
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from
 function arguments
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, kernel@stlinux.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com
Date: Thu, 20 Mar 2014 04:48:10 -0700
In-Reply-To: <20140320114123.GE21349@lee--X1>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
	 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
	 <1395314713.7776.17.camel@joe-AO722> <20140320114123.GE21349@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 11:41 +0000, Lee Jones wrote:
> On Thu, 20 Mar 2014, Joe Perches wrote:
> 
> > On Thu, 2014-03-20 at 11:11 +0000, Lee Jones wrote:
> > > Reported-by: Brian Norris <computersforpeace@gmail.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Why are these useless?
> > 
> > Even if the object code produced is the same,
> > these serve as information to the human reader
> > about how the arguments are used.
> 
> https://lkml.org/lkml/2014/3/20/69
> 

>From that email:

suggestion:

	const uint8_t *const buf  => const uint8_t *buf
	const uint32_t size       => uint32_t size
	const uint32_t offset     => uint32_t offset

What was done:

-static int stfsm_write_fifo(struct stfsm *fsm,
-                           const uint32_t *buf, const uint32_t size)
+static int stfsm_write_fifo(struct stfsm *fsm, uint32_t *buf, uint32_t size)

Note the removal of the const from uint32_t *buf

Why?


