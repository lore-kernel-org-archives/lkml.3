Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3GAO2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:28:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3GAO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:28:05 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=oIEZGPuJLxwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CR7bNRtPQ3kA:10 a=QaJepPBB2cp__h1FtHcA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372688882.22688.1.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] udp: make use of static_key_slow_set_true()
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@akamai.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Date: Mon, 01 Jul 2013 10:28:02 -0400
In-Reply-To: <51D10390.4060905@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
	  <7fe0eaba62a8529b387ddb3205713d8bb6156ec1.1372457176.git.jbaron@akamai.com>
	 <1372475620.18733.353.camel@gandalf.local.home>
	 <51D10390.4060905@akamai.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 00:20 -0400, Jason Baron wrote:
>   
> >> @@ -1450,7 +1449,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >>   		goto drop;
> >>   	nf_reset(skb);
> >>   
> >> -	if (static_key_false(&udp_encap_needed) && up->encap_type) {
> >> +	if (static_key_false(&udp_encap_needed.key) && up->encap_type) {
> > I wonder if we should add a static_bool_key_false(), because that added
> > ".key" is a bit confusing.
> >
> > -- Steve
> >
> 
> Yeah - that is sort of ugly, but it avoids introducing a new branch API 
> call. That said, a 'static_bool_key_false()' would probably be a simple 
> wrapper function.

My main concern was to keep true/false separate from counters to
document how this is being used. A simple wrapper would work too.

-- Steve


