Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFFP50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:57:26 -0400
Received: from mx0.aculab.com ([213.249.233.131]:45086 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752042AbaFFP5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:57:24 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Ken Helias'" <kenhelias@firemail.de>,
        lkml <linux-kernel@vger.kernel.org>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>
Subject: RE: [PATCH] list: Fix order of arguments for hlist_add_after(_rcu)
Thread-Topic: [PATCH] list: Fix order of arguments for hlist_add_after(_rcu)
Thread-Index: AQHPgXQ+hBdMMebuGkWiQFDRKWBroJtkPA2w
Date: Fri, 6 Jun 2014 15:56:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17258AEA@AcuExch.aculab.com>
References: <1402047743-3391-1-git-send-email-kenhelias@firemail.de>
In-Reply-To: <1402047743-3391-1-git-send-email-kenhelias@firemail.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behalf Of Ken Helias
> All other add functions for lists have the new item as first argument and the
> position where it is added as second argument. This was changed for no good
> reason in this function and makes using it unnecessary confusing.
> 
> Also the naming of the arguments in hlist_add_after was confusing. It was
> changed to use the same names as hlist_add_after_rcu.
...
> -static inline void hlist_add_after_rcu(struct hlist_node *prev,
> -				       struct hlist_node *n)
> +static inline void hlist_add_after_rcu(struct hlist_node *n,
> +				       struct hlist_node *prev)

It is rather a shame that the change doesn't generate a compilation
error for old source files.

	David



