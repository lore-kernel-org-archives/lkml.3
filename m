Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408AbaKNPA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:00:29 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62483 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbaKNPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:00:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        maxime.coquelin@st.com
Subject: Re: [PATCH v2 13/14] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Date: Fri, 14 Nov 2014 15:59:51 +0100
Message-ID: <3480005.rnSDFdcTbG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141114133425.GA28680@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org> <1546892.RCPeXgVQNJ@wuerfel> <20141114133425.GA28680@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ooakA7DfqK1P/2wKIpzRLsNlLjFMobVObUNc94W+atf
 5WMlQHY6nLSXDzedqQhGgDqvjgzBx7DBpVJgWSdYPkXHTaLcId
 mf4XmTIM11q7OAQZ46u09S89axXmWSHMwjS2UdIg//63LhUlow
 YkIxiJEkLxDo8NSfBkFEpbDdLQAze/IUhFcet4/aU8U353iPr7
 1jGJUVyKEek/swU3OAM6KuXQoZuK4t3nkrQF5Kc8CJkP2CqXh7
 /HGbTHSyeDGvDAmRlGY8+YbyeRluNYNbea1RbWVQWVOA7A2NgE
 6breJzddK44+pcEe6r7t+tvyOR6TWsqVEfMmFM5ToTBVuIahCw
 1DFXbZXVMwie6XY5Cg2w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 13:34:25 Peter Griffin wrote:
> > 
> > > From looking around in the source I see a few different ways people have done this: -
> > > 
> > > 1) Some drivers encode the data statically into the source and make a decision based on compatible string.
> > > 2) Some drivers add a couple of extra dt properties to encode the offset (spifsm in stih416)
> > > 3) Some drivers mix address spaces in the reg properties (examples given above) 
> > > 3) Probably some other ways I've not found yet
> > >
> > > Is there a blessed way of doing this? It would be nice at least for all the drivers in STI to be doing
> > > it the same as currently there seems to be a mix of implementations.
> > 
> > You can do 1 or 2, not 3.
> 
> Yep got it.
> 
> One last question, what are the rules about updating ethernet and miphy365 over
> to using this method for there sysconfig registers? 

It depends on whether you have any machines that rely on this for backwards
compatibility. If the platform support is still work in progress and you
wouldn't be able to run a machine with an upstream kernel yet, just say
in the patch description that this breaks compatibility and why it is ok
in this particular case.

If you have existing users that rely on these properties, make the
driver code handle the existing dtb files but print a warning if you
encounter them. In the documentation, you should list the new method
as required then, but you can mention that the old method might be
accepted for backwards compatibility.

	Arnd
