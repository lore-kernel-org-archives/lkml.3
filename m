Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3BEMgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:36:54 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:33674 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754130Ab3BEMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:36:48 -0500
From: "Leonid Shatz" <leonid.shatz@ravellosystems.com>
To: "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: "'Izik Eidus'" <izik.eidus@ravellosystems.com>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        <linux-kernel@vger.kernel.org>
References: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com> <alpine.LFD.2.02.1302051138370.11905@ionos> <03b201ce038f$4a2db840$de8928c0$@ravellosystems.com> <alpine.LFD.2.02.1302051155350.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302051155350.11905@ionos>
Subject: RE: [PATCH] fix hrtimer_enqueue_reprogram race
Date: Tue, 5 Feb 2013 14:36:51 +0200
Message-ID: <03b301ce039d$7a272e60$6e758b20$@ravellosystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFOdIG7lHacNtBAA3jpV21GXL0XcAIvDDp7Aba6sXwCT+OlwZk4oUIw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are already locks used inside hrtimer code, so why should users
> > of the hrtimer add another layer of locks and get involved in the
> > intricacy of which cases are protected by internal hrtimer lock and
> > which are not?
> 
> Groan. The hrtimer locks are there to protect the internal data structures
of
> the hrtimer code and to ensure that hrtimer functions are proper protected
> against concurrent running callbacks. But that does not give you any kind
of
> protection versus multiple users of your hrtimer resource.
> 

I was not raising the issue of protecting the logic of hrtimer use cases -
this was not the scope of the entire issue. The issue was that internal
hrtimer locks were getting screwed and it was not reasonable to add external
layer of locks to protect internal hrtimer locks (I mean before this patch).
The fix should provide protection for internal locks and I think we both
agree on that.

Leonid

