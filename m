Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaAHC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:59:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:59328 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaAHC6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:58:47 -0500
Message-ID: <52CCBEC1.1010309@huawei.com>
Date: Wed, 8 Jan 2014 10:58:09 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3.5 17/19] mwifiex: slight optimization of addr compare
References: <52BC15E7.7050205@huawei.com> <477F20668A386D41ADCC57781B1F70430F534B5541@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F534B5541@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/8 10:50, Bing Zhao wrote:
> Hi Ding,
> 
>> Use possibly more efficient ether_addr_equal
>> instead of memcmp.
> 
>> @@ -782,8 +782,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>>  	}
>>
>>  	/* If BSSID is diff, modify current BSS parameters */
>> -	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
>> -		   ibss_coal_resp->bssid, ETH_ALEN)) {
>> +	if (!ether_addr_equal(priv->curr_bss_params.bss_descriptor.mac_address, ibss_coal_resp->bssid))
> 
> Could you break the line?
> If you run "checkpatch.pl" you will spot this warning.
> 
>>  	if (!IS_11N_ENABLED(priv) ||
>> -	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
>> +	    !ether_addr_equal_unaligned(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest)) {
> 
> Also over 80 characters here.
> 
> Thanks,
> Bing
> 

Ok, thanks

Regards
Ding

