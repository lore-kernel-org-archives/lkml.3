Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161290AbaJ3U2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:28:33 -0400
Received: from plane.gmane.org ([80.91.229.3]:56171 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbaJ3U2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:28:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 13:28:09 -0700
Message-ID: <m2u70q$gtl$2@ger.gmane.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com> <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com> <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com> <CALCETrXv_CevG7166++ZHBok0ae7mNhF83VjrRVQ2AKF22Vf_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 50.245.141.77
User-Agent: KNode/4.14
Cc: linux-api@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:

<snip>
> There should be a number measured in, say, nanoseconds in here
> somewhere.  The actual extent of the speedup is unmeasurable here.
> Also, it's worth reading at least one of Linus' many rants about
> zero-copy.  It's not an automatic win.

It's well-understood that it's not an automatic win; significant testing on 
multiple architectures indicated that 512K is a surprisingly universal 
crossover point. The userspace code, therefore, switches from copying 
(normal kdbus parameters) to zero-copy (memfds) right around there.

