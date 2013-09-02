Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3IBIhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab3IBIhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:37:45 -0400
Message-ID: <52244E52.3060408@redhat.com>
Date: Mon, 02 Sep 2013 16:37:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 6/6] vhost_net: correctly limit the max pending buffers
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com> <1377836962-49780-7-git-send-email-jasowang@redhat.com> <20130902055609.GC19838@redhat.com> <52243071.5090303@redhat.com>
In-Reply-To: <52243071.5090303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 02:30 PM, Jason Wang wrote:
> On 09/02/2013 01:56 PM, Michael S. Tsirkin wrote:
>> > On Fri, Aug 30, 2013 at 12:29:22PM +0800, Jason Wang wrote:
>>> >> As Michael point out, We used to limit the max pending DMAs to get better cache
>>> >> utilization. But it was not done correctly since it was one done when there's no
>>> >> new buffers submitted from guest. Guest can easily exceeds the limitation by
>>> >> keeping sending packets.
>>> >>
>>> >> So this patch moves the check into main loop. Tests shows about 5%-10%
>>> >> improvement on per cpu throughput for guest tx. But a 5% drop on per cpu
>>> >> transaction rate for a single session TCP_RR.
>> > Any explanation for the drop? single session TCP_RR is unlikely to
>> > exceed VHOST_MAX_PEND, correct?
> Unlikely to exceed. Recheck the result, looks like it was not stable
> enough. Will re-test and report.

Re-tested with more iterations, result shows no difference on TCP_RR
test and 5%-10% improvement on per cpu throughput for guest tx.

Will post V3 soon.
