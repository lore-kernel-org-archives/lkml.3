Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaJQL0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:26:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28195 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaJQLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:25:58 -0400
X-AuditID: cbfee68f-f791c6d000004834-ae-5440fcc34d1a
Date: Fri, 17 Oct 2014 17:12:29 +0530
From: Rohit <rohit.kr@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishnu.ps@samsung.com,
        iqbal.ams@samsung.com, ed.savinay@samsung.com, me.rohit@live.com,
        pintu_agarwal@yahoo.com
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
Message-id: <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
In-reply-to: <543FF121.7000502@schaufler-ca.com>
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
 <543FF121.7000502@schaufler-ca.com>
Organization: Samsung
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkRvfwH4cQg1ffDS3mrF/DZnFv2y82
	i5eHNC0W7V7AZDH71yQmi77HQRaXd81hs/jQ84jN4vo9e4u+74fZLb69vc1ucf7COXaLKX13
	GR14Pa7tjvQ4MeM3i0fHrQZWj49Pb7F49G1ZxehxdP8iNo/Pm+Q8Zs06zBTAEcVlk5Kak1mW
	WqRvl8CVcXJOUMEvqYpnq9vZGhgniHYxcnJICJhIbFnTyQ5hi0lcuLeeDcQWEljKKLG03xem
	5uaDC4xdjFxA8UWMEh3TDrNBOL1MEl+v/mYFqWIRUJVYcf4hC4jNJqAk8f/VXLBJIgI6Evv2
	PAfbwCywgUni5SVhEFtYIEqiZ+FyoKkcHLwCThJ7OsJBwpwCBhK3HjdCHZEl8f7OBrCR/AKi
	EocXbmeGOMhGYvXOdWA2r4CgxI/J91ggxmtJbN7WxAphy0tsXvOWGeROCYGpHBJt+6cyQ9wp
	IPFt8iEWkL0SArISmw5AzZSUOLjiBssERvFZSMbOQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6xUn
	5haX5qXrJefnbmIERvfpf8/6dzDePWB9iFGAg1GJh5chxiFEiDWxrLgy9xCjKdAVE5mlRJPz
	gSkkryTe0NjMyMLUxNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJ66
	70q23tmyO7BynuE//gsmKVNb/xnYcDEqCbZf6dlUcPnpo7Q7WVc3HzK88bL+ianvM5fTVT1n
	o2Y/c6pcGmOScib7hptr1q96Ez7hbP28hPf8jx3eL7bSctwb+vXmzwczTOYXHprQFxCyPHcS
	k5TWtwaXrG+XpmZujfx01K4z9SLD9Mb8KUosxRmJhlrMRcWJAOITEBvpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd3DfxxCDGZ1aVjMWb+GzeLetl9s
	Fi8PaVos2r2AyWL2r0lMFn2Pgywu75rDZvGh5xGbxfV79hZ93w+zW3x7e5vd4vyFc+wWU/ru
	MjrwelzbHelxYsZvFo+OWw2sHh+f3mLx6NuyitHj6P5FbB6fN8l5zJp1mCmAI6qB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bJOUEFv6Qqnq1uZ2tgnCDaxcjJISFgInHz
	wQVGCFtM4sK99WxdjFwcQgKLGCU6ph2GcnqZJL5e/c0KUsUioCqx4vxDFhCbTUBJ4v+ruWwg
	toiAjsS+Pc/ZQWxmgQ1MEi8vCYPYwgJREj0LlwNt4ODgFXCS2NMRDhLmFDCQuPW4EaxVSCBL
	4v2dDWAj+QVEJQ4v3M4McZCNxOqd68BsXgFBiR+T77FAjNeS2LytiRXClpfYvOYt8wRGwVlI
	ymYhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODk8UxqB+PKBotDjAIcjEo8
	vAwxDiFCrIllxZW5hxglOJiVRHj7bwGFeFMSK6tSi/Lji0pzUosPMZoCA2Yis5Rocj4wseWV
	xBsam5ibGptamliYmFkqifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamBUuKNaeH3SpMWzZ8+V
	6XvaEbhUKEV296ucqFjmMg+zZbUV5jEvHomb3th4SnLp4kTRtf+n2zVIzr+4WXV957v0EinL
	ZUpFqeEFx+Z/37e1W1sp2XjRDjcGnpt/hV58Sff4mCtTz3UzbZfiFR37fMXd50VvbXvOGGl2
	XEVv8SL2dcuPWR22Tt6uxFKckWioxVxUnAgA5aJYqjQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 09:24:01 -0700
Casey Schaufler <casey@schaufler-ca.com> wrote:

> On 10/15/2014 5:10 AM, Rohit wrote:
> > The patch use kmem_cache to allocate/free inode_smack since they are
> > alloced in high volumes making it a perfect case for kmem_cache.
> >
> > As per analysis, 24 bytes of memory is wasted per allocation due
> > to internal fragmentation. With kmem_cache, this can be avoided.
> 
> What impact does this have on performance? I am much more
> concerned with speed than with small amount of memory.
> 
I think there should not be any performance problem as such.
However, please let me know how to check the performance in this case.

As far as i know, kzalloc first finds the kmalloc_index corresponding to
the size to get the kmem_cache_object and then calls kmem_cache_alloc
with the kmalloc_index(kmem_cache object). Here, we create kmem_cache
object specific for inode_smack and directly calls kmem_cache_alloc()
which should give better performance as compared to kzalloc.

Please let me know your comments.
> >
> > Accounting of memory allocation is below :
> >  total       slack            net      count-alloc/free
> > caller Before (with kzalloc)
> > 1919872      719952          1919872      29998/0
> > new_inode_smack+0x14
> >
> > After (with kmem_cache)
> > 1201680          0           1201680      30042/0
> > new_inode_smack+0x18
> >
> > >From above data, we found that 719952 bytes(~700 KB) of memory is
> > saved on allocation of 29998 smack inodes.
> >
> > Signed-off-by: Rohit <rohit.kr@samsung.com>
> > ---
> > Added static in kmem_cache object declaration noted by Andrew
> > Morton <akpm@ linux-foundation.org> . Also updated commit message.
> >  security/smack/smack_lsm.c |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index d515ec2..15d985c 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -53,6 +53,7 @@
> >  #define SMK_SENDING	2
> >  
> >  LIST_HEAD(smk_ipv6_port_list);
> > +static struct kmem_cache *smack_inode_cache;
> >  
> >  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
> >  static void smk_bu_mode(int mode, char *s)
> > @@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(struct
> > smack_known *skp) {
> >  	struct inode_smack *isp;
> >  
> > -	isp = kzalloc(sizeof(struct inode_smack), GFP_NOFS);
> > +	isp = kmem_cache_zalloc(smack_inode_cache, GFP_NOFS);
> >  	if (isp == NULL)
> >  		return NULL;
> >  
> > @@ -767,7 +768,7 @@ static int smack_inode_alloc_security(struct
> > inode *inode) */
> >  static void smack_inode_free_security(struct inode *inode)
> >  {
> > -	kfree(inode->i_security);
> > +	kmem_cache_free(smack_inode_cache, inode->i_security);
> >  	inode->i_security = NULL;
> >  }
> >  
> > @@ -4264,10 +4265,16 @@ static __init int smack_init(void)
> >  	if (!security_module_enable(&smack_ops))
> >  		return 0;
> >  
> > +	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
> > +	if (!smack_inode_cache)
> > +		return -ENOMEM;
> > +
> >  	tsp = new_task_smack(&smack_known_floor,
> > &smack_known_floor, GFP_KERNEL);
> > -	if (tsp == NULL)
> > +	if (tsp == NULL) {
> > +		kmem_cache_destroy(smack_inode_cache);
> >  		return -ENOMEM;
> > +	}
> >  
> >  	printk(KERN_INFO "Smack:  Initializing.\n");
> >  
> 

Thanks,
Rohit
