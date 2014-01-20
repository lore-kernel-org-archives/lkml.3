Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750765AbaATFDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:03:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaATFDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:03:04 -0500
Message-ID: <52DCADEE.3020309@redhat.com>
Date: Mon, 20 Jan 2014 13:02:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH net] tun: handle copy failure in tun_put_user()
References: <1390187808-5462-1-git-send-email-jasowang@redhat.com> <20140119.194856.491294439635992592.davem@davemloft.net>
In-Reply-To: <20140119.194856.491294439635992592.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 11:48 AM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 20 Jan 2014 11:16:48 +0800
>
>> This patch return the error code of copy helpers in tun_put_user() instead of
>> ignoring them.
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> If you perform some of the copy successfully, you have to report that
> length rather than just an error.
>
> Otherwise userland has no way to determine how much of the data was
> successfully sourced.
>
> I'm not applying this, sorry.

Right, looks like we need more changes in tun to return the accurate
length copied in this case.
