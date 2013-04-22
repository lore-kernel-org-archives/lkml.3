Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3DVUh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:37:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40384
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238Ab3DVUhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:37:54 -0400
Message-ID: <1366663056.8337.7.camel@laptop>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Apr 2013 22:37:36 +0200
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
	 <1366285369.19383.19.camel@laptop>
	 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
	 <20130418133927.GJ79013@redhat.com>
	 <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 00:50 +0000, Pan, Zhenjie wrote:
> This make watchdog reset happen before hard lockup detect.

Doesn't your watchdog trigger an NMI you can use to print the panic?

ISTR some people (hi Don!) spending quite a lot of time to make this
work for some other platforms.

IIRC those things would fire an NMI at some point and then hard-reset
the machine not much later.. the difficulty was detecting this
'unclaimed' nmi and allowing drivers to register for it.

NMI_UNKNOWN and unknown_nmi_panic are the result of that.

