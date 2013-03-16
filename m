Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3CPSY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:24:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37470 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3CPSY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:24:57 -0400
MIME-Version: 1.0
Message-ID: <6041f181-67b1-4f71-bd5c-cfb48f1ddfb0@default>
Date: Sat, 16 Mar 2013 11:24:20 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH v2 1/4] introduce zero filled pages handler
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1363255697-19674-2-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130316130302.GA5987@konrad-lan.dumpdata.com>
In-Reply-To: <20130316130302.GA5987@konrad-lan.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> Subject: Re: [PATCH v2 1/4] introduce zero filled pages handler
> 
> > +
> > +	for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++) {
> > +		if (page[pos])
> > +			return false;
> 
> Perhaps allocate a static page filled with zeros and just do memcmp?

That seems like a bad idea.  Why compare two different
memory locations when comparing one memory location
to a register will do?

