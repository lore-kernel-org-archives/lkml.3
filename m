Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaFXRX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:23:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaFXRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:23:56 -0400
Message-ID: <53A9B485.9000303@oracle.com>
Date: Tue, 24 Jun 2014 13:25:25 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, toshi.kani@hp.com, x86@kernel.org,
        mingo@redhat.com, hpa@zytor.com, xen-devel@lists.xenproject.org,
        tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH v7] x86: initialize secondary CPU only if
 master CPU will wait for it
References: <1403266991-12233-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1403266991-12233-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 08:23 AM, Igor Mammedov wrote:
> Hang is observed on virtual machines during CPU hotplug,
> especially in big guests with many CPUs. (It reproducible
> more often if host is over-committed).
>
> It happens because master CPU gives up waiting on
> secondary CPU and allows it to run wild. As result
> AP causes locking or crashing system. For example
> as described here: https://lkml.org/lkml/2014/3/6/257
>
> If master CPU have sent STARTUP IPI successfully,
> and AP signalled to master CPU that it's ready
> to start initialization, make master CPU wait
> indefinitely till AP is onlined.
> To ensure that AP won't ever run wild, make it
> wait at early startup till master CPU confirms its
> intention to wait for AP. If AP doesn't respond in 10
> seconds, the master CPU will timeout and cancel
> AP onlining.
>
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

On Xen:

Tested-by: Boris Ostrovsky <boris.ostrovsky@orace.com>

