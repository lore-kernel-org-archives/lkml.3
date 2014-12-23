Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaLWJwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:52:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLWJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:52:05 -0500
Date: Tue, 23 Dec 2014 10:51:21 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 3/4] perf Documentation: add event parameters
Message-ID: <20141223095121.GA22265@krava.brq.redhat.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-4-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141222143943.GB29096@krava.brq.redhat.com>
 <20141222193436.GB19784@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222193436.GB19784@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:34:36AM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Sun, Dec 21, 2014 at 11:49:26PM -0800, Sukadev Bhattiprolu wrote:
> | > From: Cody P Schafer <cody@linux.vnet.ibm.com>
> | > +		In the case of the last example, a value replacing "?" would
> | > +		need to be provided by the user selecting the particular event.
> | > +		This is referred to as "event parameterization". All
> | > +		non-numerical values indicate an event parameter.
> | 
> | I see.. here's the glitch ;-) I thought we agreed on forcing '?'
> | as the value for param events, not 'All non-numerical values'
> 
> Yes, it is currently more broad than needed, but it is not really
> user input - we are just parsing sysfs entries that developer specified
> in the kernel. If necessary, we can tighten that independently ?

I think it's better to tighten it up from the beginning, so when
we decide later for other string usage, we will not breake the
'current behaviour'.

Like if now we allow users (kernel pmu modules) to put anything
as param event's value, we will brake their expectations/code if
we later decide for another usage of that string value.

As Cody wrong in last version thread:
---
Compared to monopolizing all strings (which is what I did when
initialy writing this), using a '$' prefix would allow less pain when
some events suddenly need non-integer parameters.
---

thanks,
jirka
