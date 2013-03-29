Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3C2TzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:55:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3C2TzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:55:16 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=W6PAbytqgoIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bpkUmt_rH-IA:10 a=OcrEhouG9PnMzOj8FpMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364586913.10629.40.camel@gandalf.local.home>
Subject: Re: [BUG] Crash with NULL pointer dereference in bond_handle_frame
 in -rt (possibly mainline)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, stephen@networkplumber.org
Date: Fri, 29 Mar 2013 15:55:13 -0400
In-Reply-To: <1364582184.10629.34.camel@gandalf.local.home>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
	 <20130329094856.GB1677@minipsycho.orion>
	 <1364582184.10629.34.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 14:36 -0400, Steven Rostedt wrote:

This one's for you Paul ;-)

That means Eric's solution fits perfectly well here.

	< system in single state : everyone sees cat = alive >

	insert_into_box(cat);

	< system in dual state : new calls see cat == dead, but
	  current calls see cat == alive >

	open_box();

	< system is back to single state: everyone sees cat = dead >

	funeral(cat); 

no problem ;-)

-- Steve



