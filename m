Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3BFR1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:27:43 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64221 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab3BFR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:27:38 -0500
Message-ID: <51129282.7040100@redhat.com>
Date: Wed, 06 Feb 2013 18:27:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [PATCH 2/2] virtio-scsi: reset virtqueue affinity when doing
 cpu hotplug
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <50F525E3.1000100@cn.fujitsu.com> <50F52677.80100@cn.fujitsu.com> <871udlztui.fsf@rustcorp.com.au> <50F624BA.20208@cn.fujitsu.com>
In-Reply-To: <50F624BA.20208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/01/2013 04:55, Wanlong Gao ha scritto:
>>> >> Add hot cpu notifier to reset the request virtqueue affinity
>>> >> when doing cpu hotplug.
>> > 
>> > You need to be careful to get_online_cpus() and put_online_cpus() here,
>> > so CPUs can't go up and down in the middle of operations.
>> > 
>> > In particular, get_online_cpus()/put_online_cpus() around calls to
>> > virtscsi_set_affinity() (except within notifiers).
> Yes, I'll take care of this, thank you.
> 

I squashed patch 1 (plus changes to get/put_online_cpus) in my
multiqueue series, and applied this one as a separate patch.

Paolo
