Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967034Ab3DRLnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:43:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46284
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903Ab3DRLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:43:04 -0400
Message-ID: <1366285369.19383.19.camel@laptop>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: "'paulus@samba.org'" <paulus@samba.org>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        "'acme@ghostprotocols.net'" <acme@ghostprotocols.net>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'dzickus@redhat.com'" <dzickus@redhat.com>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 18 Apr 2013 13:42:49 +0200
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 06:57 +0000, Pan, Zhenjie wrote:
> Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
> But when cpu's frequency changes, the event period will also change.
> It's not as expected as the configration.
> For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
> If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
> So it may make hard lockup detect not work if the watchdog timeout is not long enough.
> Now, set a notifier to listen to the cpu frequency change.
> And dynamic re-config the NMI event to make the event period correct.
> 


Urgh,. does this really matter.. all we really want is for that NMI to
hit eventually in the not too distant future. Does the frequency really
matter _that_ much?

Also, can't we simply pick an event that's invariant to the cpufreq
nonsense? Something like CPU_CLK_UNHALTED.REF -- or better the
fixed_ctr2 which nobody ever uses anyway.

