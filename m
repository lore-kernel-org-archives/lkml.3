Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaIDM3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaIDM3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:29:31 -0400
Date: Thu, 4 Sep 2014 14:29:01 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
Message-ID: <20140904122901.GA17454@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20140712181328.GA8738@redhat.com>
 <54079B70.4050200@hurleysoftware.com>
 <1409785893.30640.118.camel@pasglop>
 <21512.10628.412205.873477@gargle.gargle.HOWL>
 <20140904090952.GW17454@tucnak.redhat.com>
 <540859EC.5000407@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540859EC.5000407@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 08:24:12AM -0400, Peter Hurley wrote:
> And I just confirmed with the Alpha cross-compiler that the fields are
> not 'padded out' if volatile either.

They can't be, struct layout is part of the ABI.
Guess you can introduce say atomic_bool and similar typedefs which would be
bool or char on most arches and on alpha int.

	Jakub
