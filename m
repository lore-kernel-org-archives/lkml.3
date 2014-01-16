Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaAPSut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:50:49 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:30752 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaAPSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:50:46 -0500
Message-ID: <1389898239.11912.61.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next 2/2] reciprocal_divide: correction/update of
 the algorithm
From: Ben Hutchings <bhutchings@solarflare.com>
To: Christoph Lameter <cl@linux.com>
CC: Daniel Borkmann <dborkman@redhat.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Jesse Gross <jesse@nicira.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "Veaceslav Falico" <vfalico@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "Jakub Zawadzki" <darkjames-ws@darkjames.pl>
Date: Thu, 16 Jan 2014 18:50:39 +0000
In-Reply-To: <alpine.DEB.2.10.1401161036110.29778@nuc>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
	 <1389828228-30312-3-git-send-email-dborkman@redhat.com>
	 <alpine.DEB.2.10.1401161036110.29778@nuc>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20438.001
X-TM-AS-Result: No--22.408400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 10:37 -0600, Christoph Lameter wrote:
> On Thu, 16 Jan 2014, Daniel Borkmann wrote:
> 
> > - * or else the performance is slower than a normal divide.
> > - */
> > -extern u32 reciprocal_value(u32 B);
> > +struct reciprocal_value {
> > +	u32 m;
> > +	u8 sh1, sh2;
> > +};
> >
> > +#define RECIPROCAL_VALUE_RESULT_TO_ZERO ((struct reciprocal_value){.sh1 = 32})
> >
> > -static inline u32 reciprocal_divide(u32 A, u32 R)
> > +struct reciprocal_value reciprocal_value(u32 d);
> 
> A function that returns a struct? That works? Which gcc versions support
> it?

At least since gcc 1.29, given:

Thu Sep 22 15:57:41 1988  Richard Stallman  (rms at sugar-bombs.ai.mit.edu)
[...]
	* stmt.c (expand_function_start): Set current_function_needs_context
	and current_function_returns_struct.

Hope that's not a problem...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

