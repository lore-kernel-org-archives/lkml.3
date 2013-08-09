Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030785Ab3HITMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030485Ab3HITMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:12:31 -0400
Date: Fri, 9 Aug 2013 12:12:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hedberg <johan.hedberg@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaganath Kanakkassery <jaganath.k@samsung.com>,
        Chan-Yeol Park <chanyeol.park@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: Re: [ 045/102] Bluetooth: Fix invalid length check in
 l2cap_information_rsp()
Message-ID: <20130809191230.GE10130@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <20130809015020.460694273@linuxfoundation.org>
 <20130809075458.GA8758@x220.p-661hnu-f1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809075458.GA8758@x220.p-661hnu-f1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:54:58AM +0300, Johan Hedberg wrote:
> Hi Greg,
> 
> On Thu, Aug 08, 2013, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jaganath Kanakkassery <jaganath.k@samsung.com>
> > 
> > commit da9910ac4a816b4340944c78d94c02a35527db46 upstream.
> > 
> > The length check is invalid since the length varies with type of
> > info response.
> > 
> > This was introduced by the commit cb3b3152b2f5939d67005cff841a1ca748b19888
> > 
> > Because of this, l2cap info rsp is not handled and command reject is sent.
> > 
> > > ACL data: handle 11 flags 0x02 dlen 16
> >         L2CAP(s): Info rsp: type 2 result 0
> >           Extended feature mask 0x00b8
> >             Enhanced Retransmission mode
> >             Streaming mode
> >             FCS Option
> >             Fixed Channels
> > < ACL data: handle 11 flags 0x00 dlen 10
> >         L2CAP(s): Command rej: reason 0
> >           Command not understood
> > 
> > Signed-off-by: Jaganath Kanakkassery <jaganath.k@samsung.com>
> > Signed-off-by: Chan-Yeol Park <chanyeol.park@samsung.com>
> > Acked-by: Johan Hedberg <johan.hedberg@intel.com>
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  net/bluetooth/l2cap_core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -4240,7 +4240,7 @@ static inline int l2cap_disconnect_rsp(s
> >  	u16 dcid, scid;
> >  	struct l2cap_chan *chan;
> >  
> > -	if (cmd_len != sizeof(*rsp))
> > +	if (cmd_len < sizeof(*rsp))
> >  		return -EPROTO;
> >  
> >  	scid = __le16_to_cpu(rsp->scid);
> 
> This patch is already in 3.10 so there should be no need to try to
> backport it (not to mention that this backport itself is incorrect in
> that it modifies l2cap_disconnect_rsp whereas the original patch
> modifies l2cap_information_rsp).
> 
> For whatever reason this commit seems to exist twice in Linus' tree: once
> before the v3.10 tag with id 3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112 and
> once after the v3.10 tag with id da9910ac4a816b4340944c78d94c02a35527db46
> (which is the upstream commit id referenced by your commit message).

Thanks, this came into Linus's tree twice, I missed that.  I've now
dropped this from the 3.10-stable queue.

greg k-h
