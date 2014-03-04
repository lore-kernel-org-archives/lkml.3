Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaCDXih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:38:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:6507 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaCDXif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:38:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,589,1389772800"; 
   d="scan'208";a="486133079"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "balbi@ti.com" <balbi@ti.com>, Michal Nazarewicz <mina86@mina86.com>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
Subject: RE: [PATCH v2] usb: gadget: return the right length in
 ffs_epfile_io()
Thread-Topic: [PATCH v2] usb: gadget: return the right length in
 ffs_epfile_io()
Thread-Index: AQHPN8L/lP71JkudzE+UDTjPoRY7OprQkboAgAA/hACAAACQgIAAw97Q
Date: Tue, 4 Mar 2014 23:38:32 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C3E4C2@SHSMSX101.ccr.corp.intel.com>
References: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
 <531606DB.4010601@cogentembedded.com> <20140304160620.GH15233@saruman.home>
 <xa1td2i14u63.fsf@mina86.com> <20140304195541.GB24463@saruman.home>
In-Reply-To: <20140304195541.GB24463@saruman.home>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Wednesday, March 05, 2014 3:56 AM
> To: Michal Nazarewicz
> Cc: Robert Baldyga; Felipe Balbi; Sergei Shtylyov; Liu, Chuansheng;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; david.a.cohen@linux.intel.com
> Subject: Re: [PATCH v2] usb: gadget: return the right length in ffs_epfile_io()
> 
> On Tue, Mar 04, 2014 at 08:53:40PM +0100, Michal Nazarewicz wrote:
> > >> On 03/04/2014 10:34 AM, Chuansheng Liu wrote:
> > >> >@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file,
> struct ffs_io_data *io_data)
> > >> >  			 * we may end up with more data then user space has
> > >> >  			 * space for.
> > >> >  			 */
> > >> >-			ret = ep->status;
> > >> >-			if (io_data->read && ret > 0 &&
> > >> >-			    unlikely(copy_to_user(io_data->buf, data,
> > >> >-						  min_t(size_t, ret,
> > >> >-						  io_data->len))))
> > >> >-				ret = -EFAULT;
> > >> >+				ret = ep->status;
> >
> > On Tue, Mar 04 2014, Felipe Balbi wrote:
> > >>    Why the indentation jumped suddenly to the right?
> >
> > > On Tue, Mar 04, 2014 at 08:01:15PM +0300, Sergei Shtylyov wrote:
> > > because it was wrong before ;-)
> >
> > Yep.  It looks like Robert's [2e4c7553: add aio support] introduced an
> > if-else-if-else flow but did not indent the code and I didn't caught it
> > when reviewing that patch.
> 
> it's in my testing/next now, I also fixed the comment indentation which
> was also wrong.
Thanks your help and the fix for comment indentation also:)

Best Regards
Chuansheng
