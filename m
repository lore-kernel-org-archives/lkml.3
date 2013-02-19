Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3BSIEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:04:07 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57335 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3BSIED convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 19 Feb 2013 03:04:03 -0500
Message-Id: <51233FF502000078000BF4AE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 19 Feb 2013 08:03:49 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Miller" <davem@davemloft.net>, <drjones@redhat.com>
Cc: <ian.campbell@citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: netback: remove redundant
 xenvif_put
References: <1361219360-29176-1-git-send-email-drjones@redhat.com>
 <20130219.005356.2288460992654639558.davem@davemloft.net>
In-Reply-To: <20130219.005356.2288460992654639558.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.02.13 at 06:53, David Miller <davem@davemloft.net> wrote:
> From: Andrew Jones <drjones@redhat.com>
> Date: Mon, 18 Feb 2013 21:29:20 +0100
> 
>> netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
>> a xenvif_put(). As callers of netbk_fatal_tx_err should only
>> have one reference to the vif at this time, then the xenvif_put
>> in netbk_fatal_tx_err is one too many.
>> 
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Applied.

But this is wrong from all we can tell, we discussed this before
(Wei pointed to the discussion in an earlier reply). The core of
it is that the put here parallels the one in netbk_tx_err(), and
the one in xenvif_carrier_off() matches the get from
xenvif_connect() (which normally would be done on the path
coming through xenvif_disconnect()).

And anyway - shouldn't changes to netback require an ack from
Ian?

Jan

