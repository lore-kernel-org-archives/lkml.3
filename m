Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab3JPA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:28:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54169 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab3JPA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:28:33 -0400
Message-ID: <1381883311.2045.87.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Tue, 15 Oct 2013 17:28:31 -0700
In-Reply-To: <20131015160236.GG2592@two.firstfloor.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <87siw4xy9i.fsf@tassilo.jf.intel.com>
	 <20131014202528.GG26880@hmsreliant.think-freely.org>
	 <20131015091251.2345b918@b012350-ux>
	 <20131015133336.GF2592@two.firstfloor.org>
	 <20131015155615.738f03d5@b012350-ux>
	 <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131015161528.08c19e92@b012350-ux>
	 <1381847168.2045.45.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381848748.2045.50.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131015160236.GG2592@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 18:02 +0200, Andi Kleen wrote:
> > I get the csum_partial() if disabling prequeue.
> 
> At least in the ipoib case i would consider that a misconfiguration.

There is nothing you can do, if application is not blocked on recv(),
but using poll()/epoll()/select(), prequeue is not used at all.

In this case, we need to csum_partial() frame before sending an ACK,
don't you think ? ;)



