Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaD0WUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:20:19 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49969 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaD0WUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:20:18 -0400
Subject: Re: [PATCH 1/5] staging/lustre/lnet: fix potential null pointer dereference
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140427230548.347fbb21@alan.etchedpixels.co.uk>
Date: Sun, 27 Apr 2014 18:19:59 -0400
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dmitry Eremin <dmitry.eremin@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0B38703A-0903-469F-B2A3-D71E7E1D19E9@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru> <1398633446-16719-2-git-send-email-green@linuxhacker.ru> <20140427230548.347fbb21@alan.etchedpixels.co.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 27, 2014, at 6:05 PM, One Thousand Gnomes wrote:

>> Reviewed-by: John L. Hammond <john.hammond@intel.com>
>> Reviewed-by: Isaac Huang <he.huang@intel.com>
>> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
>> ---
>> drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
>> index 21d36ee..516f623 100644
>> --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
>> +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
>> @@ -829,14 +829,14 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
>> 				best_npeers = iface->ksni_npeers;
>> 			}
>> 
>> +			LASSERT(best_iface != NULL);
>> +
> 
> And this solves the problem how ???

This does not really solve anything.
Just moves the check to where it's actually going to do anything instead of the check being guarded by the NULL pointer access earlier on.
Could have been removed instead of course to just get an oops at all times.