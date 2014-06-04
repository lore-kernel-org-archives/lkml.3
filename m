Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaFDRRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:17:34 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:40890 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaFDRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:17:33 -0400
Date: Wed, 4 Jun 2014 12:17:31 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu-refcount: fix usage of this_cpu_ops (was Re:
 hanging aio process)
In-Reply-To: <20140604164106.GI5004@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1406041217060.12469@gentwo.org>
References: <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com> <alpine.LFD.2.11.1405201945280.1631@denkbrett>
 <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com> <alpine.LFD.2.11.1405210954110.1579@denkbrett> <alpine.LFD.2.11.1405211042350.1579@denkbrett> <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
 <alpine.LFD.2.11.1406041540520.21183@denkbrett> <20140604164106.GI5004@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Tejun Heo wrote:

> Urgh... I really don't like the subtleties around __this_cpu_*().
> It's too easy to get it wrong and fail to notice it.  :(

Thats why we added the preemption check logic recently. Wonder why it did
not trigger in this case.


