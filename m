Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab3CSPYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:24:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59408 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3CSPYM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 19 Mar 2013 11:24:12 -0400
Message-Id: <5148912802000078000C6CC4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 19 Mar 2013 15:24:08 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Roger Pau Monne" <roger.pau@citrix.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/5] xen-blkback: don't store
 dev_bus_addr
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
 <1363625376-35612-2-git-send-email-roger.pau@citrix.com>
 <20130319143217.GC32432@phenom.dumpdata.com>
 <51488A8C02000078000C6C20@nat28.tlf.novell.com>
 <20130319151000.GA8550@phenom.dumpdata.com>
In-Reply-To: <20130319151000.GA8550@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.03.13 at 16:10, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Tue, Mar 19, 2013 at 02:55:56PM +0000, Jan Beulich wrote:
>> >>> On 19.03.13 at 15:32, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > @@ -971,7 +962,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>> >  		       (bio_add_page(bio,
>> >  				     pages[i],
>> >  				     seg[i].nsec << 9,
>> > -				     seg[i].buf & ~PAGE_MASK) == 0)) {
>> > +				     seg[i].offset & ~PAGE_MASK) == 0)) {
>> 
>> ... this one could as well use the original field.
>> 
>> And the masking with ~PAGE_MASK is not pointless in any case.
> 
> Good point. In which might as well make the 'struct seg_buf' be an
> simple array of unsigned int.

Looks like you understood that the "not" in my earlier response
was meant to be "now".

Jan

