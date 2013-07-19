Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3GSXpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:45:36 -0400
Received: from science.horizon.com ([71.41.210.146]:39211 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750957Ab3GSXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:45:35 -0400
Date: 19 Jul 2013 19:45:34 -0400
Message-ID: <20130719234534.4596.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, linux@horizon.com
Subject: Re: 3.10.0 i386 uniprocessor panic
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <51E9BCC9.7070909@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A disassembly of the calling function, i.e.:
> 
>  [<c1024524>] ? run_timer_softirq+0x150/0x165
> 
> ... would be a good idea, at least.

Here you go.  Note that the machine isn't doing anything of interest,
so after a quick search for residual personal data I could give you a
root login on it.  (Just send ssh key.)

kernel/timer.o:     file format elf32-i386

Disassembly of section .text:

[snip...]

00000289 <run_timer_softirq>:
 289:	55                   	push   %ebp
 28a:	57                   	push   %edi
 28b:	56                   	push   %esi
 28c:	53                   	push   %ebx
 28d:	83 ec 24             	sub    $0x24,%esp
 290:	8b 1d 00 00 00 00    	mov    0x0,%ebx
 296:	e8 fc ff ff ff       	call   297 <run_timer_softirq+0xe>
 29b:	a1 00 00 00 00       	mov    0x0,%eax
 2a0:	3b 43 04             	cmp    0x4(%ebx),%eax
 2a3:	0f 88 3d 01 00 00    	js     3e6 <run_timer_softirq+0x15d>
 2a9:	fa                   	cli    
 2aa:	8d 83 10 08 00 00    	lea    0x810(%ebx),%eax
 2b0:	89 44 24 14          	mov    %eax,0x14(%esp)
 2b4:	8d 83 10 0a 00 00    	lea    0xa10(%ebx),%eax
 2ba:	89 44 24 18          	mov    %eax,0x18(%esp)
 2be:	a1 00 00 00 00       	mov    0x0,%eax
 2c3:	8b 4b 04             	mov    0x4(%ebx),%ecx
 2c6:	39 c8                	cmp    %ecx,%eax
 2c8:	0f 88 11 01 00 00    	js     3df <run_timer_softirq+0x156>
 2ce:	0f b6 f1             	movzbl %cl,%esi
 2d1:	85 f6                	test   %esi,%esi
 2d3:	75 5a                	jne    32f <run_timer_softirq+0xa6>
 2d5:	8b 54 24 14          	mov    0x14(%esp),%edx
 2d9:	c1 e9 08             	shr    $0x8,%ecx
 2dc:	89 d8                	mov    %ebx,%eax
 2de:	83 e1 3f             	and    $0x3f,%ecx
 2e1:	e8 e3 fe ff ff       	call   1c9 <cascade>
 2e6:	85 c0                	test   %eax,%eax
 2e8:	75 45                	jne    32f <run_timer_softirq+0xa6>
 2ea:	8b 4b 04             	mov    0x4(%ebx),%ecx
 2ed:	8b 54 24 18          	mov    0x18(%esp),%edx
 2f1:	89 d8                	mov    %ebx,%eax
 2f3:	c1 e9 0e             	shr    $0xe,%ecx
 2f6:	83 e1 3f             	and    $0x3f,%ecx
 2f9:	e8 cb fe ff ff       	call   1c9 <cascade>
 2fe:	85 c0                	test   %eax,%eax
 300:	75 2d                	jne    32f <run_timer_softirq+0xa6>
 302:	8b 4b 04             	mov    0x4(%ebx),%ecx
 305:	8d 93 10 0c 00 00    	lea    0xc10(%ebx),%edx
 30b:	89 d8                	mov    %ebx,%eax
 30d:	c1 e9 14             	shr    $0x14,%ecx
 310:	83 e1 3f             	and    $0x3f,%ecx
 313:	e8 b1 fe ff ff       	call   1c9 <cascade>
 318:	85 c0                	test   %eax,%eax
 31a:	75 13                	jne    32f <run_timer_softirq+0xa6>
 31c:	8b 4b 04             	mov    0x4(%ebx),%ecx
 31f:	8d 93 10 0e 00 00    	lea    0xe10(%ebx),%edx
 325:	89 d8                	mov    %ebx,%eax
 327:	c1 e9 1a             	shr    $0x1a,%ecx
 32a:	e8 9a fe ff ff       	call   1c9 <cascade>
 32f:	8d 0c f3             	lea    (%ebx,%esi,8),%ecx
 332:	ff 43 04             	incl   0x4(%ebx)
 335:	8d 54 24 1c          	lea    0x1c(%esp),%edx
 339:	8b 71 10             	mov    0x10(%ecx),%esi
 33c:	8d 41 10             	lea    0x10(%ecx),%eax
 33f:	89 54 24 10          	mov    %edx,0x10(%esp)
 343:	89 56 04             	mov    %edx,0x4(%esi)
 346:	89 74 24 1c          	mov    %esi,0x1c(%esp)
 34a:	8b 71 14             	mov    0x14(%ecx),%esi
 34d:	89 74 24 20          	mov    %esi,0x20(%esp)
 351:	89 16                	mov    %edx,(%esi)
 353:	89 41 10             	mov    %eax,0x10(%ecx)
 356:	89 40 04             	mov    %eax,0x4(%eax)
 359:	8b 74 24 1c          	mov    0x1c(%esp),%esi
 35d:	3b 74 24 10          	cmp    0x10(%esp),%esi
 361:	0f 84 57 ff ff ff    	je     2be <run_timer_softirq+0x35>
 367:	8b 46 0c             	mov    0xc(%esi),%eax
 36a:	8b 4e 20             	mov    0x20(%esi),%ecx
 36d:	8b 7e 10             	mov    0x10(%esi),%edi
 370:	8b 6e 14             	mov    0x14(%esi),%ebp
 373:	89 c2                	mov    %eax,%edx
 375:	83 e2 02             	and    $0x2,%edx
 378:	85 c9                	test   %ecx,%ecx
 37a:	89 54 24 0c          	mov    %edx,0xc(%esp)
 37e:	74 1b                	je     39b <run_timer_softirq+0x112>
 380:	83 e0 01             	and    $0x1,%eax
 383:	8b 56 1c             	mov    0x1c(%esi),%edx
 386:	89 3c 24             	mov    %edi,(%esp)
 389:	89 44 24 08          	mov    %eax,0x8(%esp)
 38d:	8d 46 24             	lea    0x24(%esi),%eax
 390:	89 44 24 04          	mov    %eax,0x4(%esp)
 394:	89 f0                	mov    %esi,%eax
 396:	e8 fc ff ff ff       	call   397 <run_timer_softirq+0x10e>
 39b:	89 33                	mov    %esi,(%ebx)
 39d:	8b 16                	mov    (%esi),%edx
 39f:	8b 46 04             	mov    0x4(%esi),%eax
 3a2:	89 42 04             	mov    %eax,0x4(%edx)
 3a5:	89 10                	mov    %edx,(%eax)
 3a7:	f6 46 0c 01          	testb  $0x1,0xc(%esi)
 3ab:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
 3b1:	c7 46 04 00 02 20 00 	movl   $0x200200,0x4(%esi)
 3b8:	75 03                	jne    3bd <run_timer_softirq+0x134>
 3ba:	ff 4b 0c             	decl   0xc(%ebx)
 3bd:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
 3c2:	74 0b                	je     3cf <run_timer_softirq+0x146>
 3c4:	89 ea                	mov    %ebp,%edx
 3c6:	89 f8                	mov    %edi,%eax
 3c8:	e8 4f fe ff ff       	call   21c <call_timer_fn.isra.37>
 3cd:	eb 0b                	jmp    3da <run_timer_softirq+0x151>
 3cf:	fb                   	sti    
 3d0:	89 ea                	mov    %ebp,%edx
 3d2:	89 f8                	mov    %edi,%eax
 3d4:	e8 43 fe ff ff       	call   21c <call_timer_fn.isra.37>
 3d9:	fa                   	cli    
 3da:	e9 7a ff ff ff       	jmp    359 <run_timer_softirq+0xd0>
 3df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
 3e5:	fb                   	sti    
 3e6:	83 c4 24             	add    $0x24,%esp
 3e9:	5b                   	pop    %ebx
 3ea:	5e                   	pop    %esi
 3eb:	5f                   	pop    %edi
 3ec:	5d                   	pop    %ebp
 3ed:	c3                   	ret    
