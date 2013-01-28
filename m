Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3A1OkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:40:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3A1OkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:40:19 -0500
Date: Mon, 28 Jan 2013 15:40:06 +0100
From: Leandro Lucarella <leandro.lucarella@sociomantic.com>
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Cc: Nivedita Singhvi <niveditasinghvi@gmail.com>,
        Rick Jones <rick.jones2@hp.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
Message-ID: <20130128144006.GQ4608@sociomantic.com>
References: <50FF0C25.9000300@hp.com>
 <20130123104736.GK4608@sociomantic.com>
 <510039C8.7040401@hp.com>
 <20130124122223.GQ4608@sociomantic.com>
 <51018110.1070403@hp.com>
 <20130124192125.GD4608@sociomantic.com>
 <5102225E.2040506@gmail.com>
 <20130125100525.GE4608@sociomantic.com>
 <5105E6F2.2010805@gmail.com>
 <CAGK4HS_2=b3gJmDeBTbSmFYk4PB2epMUQE6nkr1XMGfFgmfHvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGK4HS_2=b3gJmDeBTbSmFYk4PB2epMUQE6nkr1XMGfFgmfHvw@mail.gmail.com>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2gLVhENgiLoCpqABYgdNML1PluzCJpev/A4UKviLz5A
 gIWJXZaL7qb0jGlpJSWIoaM97GNHq7Nxc3F5Rz85ckc4ao1eDU
 ZmfthFhDP77S+qYsdU693DMoEIjYYmlvOFj5hpUtvHrlp42jOt
 JqIN7UGwJJ+h4D82Au5sOfstnq1kqBkoYu6fMhpkQWoLSw74AU
 Q67KCWV/eAu0uUgDve3ff9uf8C/0B4LDPvCviOpw2kFWq9kRQ+
 lPItP3B0kUxOFnSS1y3vnwIlp9f2TBSyDBnfXAXwvxc3bW/FLl
 vNEEf1waXlFTAVveBGvASv36z5LUl28aiYnvJs8NtLk72LGidA
 L3UBV+wGm8bC77QENSCk5ale7YCbn634ACB5eBa+d7zu7myu4B
 apdKKJfOlcVvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 09:21:32PM -0800, Vijay Subramanian wrote:
> > +    { "ListenDrops", N_("%u SYNs to LISTEN sockets dropped"), opt_number },
> >
> > (see the file debian/patches/CVS-20081003-statistics.c_sync.patch
> >  in the net-tools src)
> >
> > i.e., the netstat pkg is printing the value of the TCPEXT MIB counter
> > that's counting TCPExtListenDrops.
> >
> > Theoretically, that number should be the same as that printed by nstat,
> > as they are getting it from the same kernel stats counter. I have not
> > looked at nstat code (I actually almost always dump the counters from
> > /proc/net/{netstat + snmp} via a simple prettyprint script (will send
> > you that offline).
> 
> nstat pretty much does what you describe which is to parse the
> /proc/net files(s) and print the contents. This is one advantage of
> nstat over netstat. When you add a new MIB, you do not need to update
> nstat.

Well, something seems to be broken in the nstat I have because using the
script to parse the start instead I get the the same values as with
netstat.

[2 minutes later, and after observing the values of nstat changed in the
same server]

OK, it looks like nstat is showing some transcient values, using nstat
-a I get the "absolute values of counters" (as stated in the man page).
By default it seems to print the values for the last 60 seconds, so
mistery solved.

-- 
Leandro Lucarella
sociomantic labs GmbH
http://www.sociomantic.com
